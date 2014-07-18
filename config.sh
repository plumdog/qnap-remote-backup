# change these:
UNAME="qnapuser"
UPASS="qnappass"
IP="qnapaddr"

TOBACKUP="/myfiles" # the directory to backup
LOCALDIR="/writeabledir" # the directory used to store the backups locally
LOCALUSER="user" # so it knows who to show notifications to

GPGUSER="GpgUser" # set this to use gpg encryption

#################################
# don't change these unless you're changing the script
FNAME=home_backup_$(date -I).tar.gz # because we assume one backup per day
LOCALPATH="$LOCALDIR$FNAME"
REMOTEPATH="ftp://$IP/homes/$UNAME/$FNAME"
EXCLUDEFILE="$DIR/backup_exclude.txt"

# must allow execution of tar, curl and notify-send. Also gpg if you have set GPGUSER
PATH="/usr/bin/"
