#!/usr/bin/R

# Purpose: to initiate and save rtweet authentication for the bot.

library(yaml)
library(rtweet)

yams <- yaml.load_file("/home/rohit/bin/twitter-api-credentials/gov-bot-credentials.yaml")

auth <- rtweet_bot(yams$consumer_key, yams$consumer_secret, yams$access_token, yams$access_token_secret)
auth_save(auth, "govbot")
auth_list()

#   auth_as("govbot")
