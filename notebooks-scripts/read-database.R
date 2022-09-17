con <- dbConnect(RSQLite::SQLite(), file.path("data", "govtweets.db"))

dbListTables(con)
dbListFields(con, "MainDataTable")
dbWriteTable(con, "MainDataTable", all_dat, append = TRUE)                           

dat_in <- dbReadTable(con, "MainDataTable") %>%
  as_tibble()

res <- dbSendQuery(con, "SELECT * FROM MainDataTable WHERE TimeStamp
BETWEEN '2022-09-01' AND '2022-09-17'")
res_d <- dbFetch(res)
dbClearResult(res)


dbDisconnect(con)