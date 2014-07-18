qnap-remote-backup
==================

For creating a backup and saving it to a QNAP via Curl.

Once cloned, edit your `config.sh` file. Also, populate your
`exclude.txt` with absolute paths to directories or files that you
want to exclude, with each one on a new line.

Now run the script. It should work if you are logged in as the
`LOCALUSER` that you set in `config.sh` or if you are root.

Now set it up to run via cron. Eg add
```bash
0 12 * * * /root/qnap-remote-backup/backup.sh
```
to root's crontab, via `crontab -e`.
