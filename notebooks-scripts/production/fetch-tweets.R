#!/usr/bin/env Rscript

# Purpose: to fetch tweets from my home timeline using since id.

suppressMessages(library(rtweet))
suppressMessages(library(yaml))
suppressMessages(library(tidyverse))
suppressMessages(library(DBI))


# Function(s)
strtime <- function(x){
  crtime <- strptime(x, "%a %b %d %H:%M:%S %z %Y", tz = "UTC")
  return(as.character(crtime))
}

# Rtweet Authentication
auth_as("govbot")

# Read since_ids
since_ids <- readRDS(file.path("data", "main", "since-ids.rds"))

# Read home timeline data and fetch associated user data
timeline_dat <- get_my_timeline(n = Inf,  since_id = since_ids,  parse = TRUE)

if(nrow(timeline_dat) > 0){
        print(paste0(nrow(timeline_dat), " new tweet(s) were fetched on ", date()))

        users_dat <- users_data(timeline_dat) %>%
          dplyr::select(id_str, screen_name, location) %>%
          dplyr::rename(c("UserID" = "id_str", "UserName" = "screen_name", "Location" = "location"))

        # Rename columns  
        tweet_dat <- timeline_dat %>% dplyr::select(created_at, id_str, full_text, lang) %>%
          dplyr::rename(c("TimeStamp" = "created_at", "TweetID"="id_str", 
                          "Tweet" = "full_text", "Language" = "lang" ))

        # Join tweet data with the user data
        all_dat <- dplyr::bind_cols(users_dat, tweet_dat) %>%
          dplyr::select(all_of(c("TweetID", "TimeStamp", "Language", "UserID",
                                 "UserName", "Tweet", "Location")))

        # Convert twitter time stamp to a string (compatible wtih SQLite and Excel)
        # All the time stamps are in UTC
        all_dat <- all_dat %>% dplyr::mutate_at(vars(TimeStamp), strtime)

        # Pull and save latest since_ids
        since_ids <- all_dat %>% dplyr::pull(TweetID)
        saveRDS(since_ids, file.path("data", "main", "since-ids.rds"))


        # Make a connection with the RSQLite database
        con <- dbConnect(RSQLite::SQLite(), file.path("data", "main", "govtweets.db"))

        ## Write data to the database
        dbWriteTable(con, "MainDataTable", all_dat, append = TRUE)                           

        ## Disconnect from the database
        dbDisconnect(con)
}else{
        print(paste0(nrow(timeline_dat), " new tweet(s) were fetched on ", date()))
}
