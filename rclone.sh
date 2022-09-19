echo "Executing rclone at" `date`
/usr/bin/rclone copy --retries 5 --transfers 2 data/main/ megaGmail:rclone/govtweets
