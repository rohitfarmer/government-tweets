# Tweets from heads of governments and states
Repository for the production and development versions of scripts and notebooks for the bot that collects tweets in pseudo-real-time (once every 15 mins) from the home timeline of https://twitter.com/HeadOffices.  

The current version of the production bot is written in R using the “rtweet” library (https://docs.ropensci.org/rtweet/index.html) that runs once every 15 mins via crontab on a Raspberry Pi 3B+. First, the fetched tweets are preprocessed, and only the desired data are stored in an SQLite database. Then, once in a while, the data is further processed and distributed on Kaggle at https://www.kaggle.com/datasets/rohitfarmer/tweets-from-the-head-of-the-governments-and-states. 

For questions, suggestions, and collaboration, contact rohitfarmer@hotmail.com.

## Crontab settings
Crontab is used to execute the production bot script once every 15 mins and `rclone` for copying the database to remote storage once a day.
 
```
15,30,45,59 * * * * cd /home/rohit/sandbox/government-tweets && bash fetchtweets.sh  > /home/rohit/sandbox/government-tweets/logs/crontab.log 2>&1
10 0 * * * cd /home/rohit/sandbox/government-tweets  && bash rclone.sh > /home/rohit/sandbox/government-tweets/logs/rclone.log 2>&1
```
## SQLite database schema
```
CREATE TABLE `MainDataTable` ( `TweetID` TEXT, `TimeStamp` TEXT, `Language` TEXT, `UserID` TEXT, `UserName` TEXT, `Tweet` TEXT, `Location` TEXT )
```


