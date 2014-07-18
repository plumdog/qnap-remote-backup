#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/config.sh"


# notifies the user of the first argument and if the second is
# "fatal", then also exits the script
function error() {
    notify "Error: $1"
    if [ "$2" = "fatal" ]
    then
		exit 1
    fi
}

function echoerr() {
	echo "$@" 1>&2
}

# for convenience
function fatal_error() {
    error "$1" "fatal"
}

# sends a notify-send message to the specified user
function notify() {
    DISPLAY=:0.0 sudo -u "$LOCALUSER" notify-send "Backup" "$1"
}

function main() {
    notify "Started"

    tar -czvf "$LOCALPATH" "$TOBACKUP" --exclude-from="$EXCLUDEFILE" || error "Compression had errors"

    if [ ! -f "$LOCALPATH" ]
    then
		fatal_error "No compressed file created"
    fi

    # Only attempt encryption if we have been given a gpg user
    if [ -n "$GPGUSER" ]
    then
		notify "Starting encryption"
		gpg --batch --yes -e -u "$GPGUSER" -r "$GPGUSER" "$LOCALPATH"
		uploadpath="$LOCALPATH".gpg
    else
		uploadpath="$LOCALPATH"
    fi

    notify "File created, starting upload"
    curl -u $UNAME:$UPASS -T "$uploadpath" "$REMOTEPATH" || fatal_error "Upload failed"
    notify "Upload complete, starting delete of old backups"
    delete_old
    notify "Complete"
}

function list() {
    curl -s -u $UNAME:$UPASS --list-only ftp://"$IP"/home/
}

function delete_old() {
    count=0
    for f in $(list | grep "home_backup_*" | sort -r | tail -n+10)
    do
		delete_remote "$f"
		count=$(($count+1))
    done

    notify "Deleted $count old backup(s)"
}

function delete_remote() {
    curl -s -u "$UNAME":"$UPASS" -Q '-DELE /homes/'$UNAME'/'"$1" ftp://"$IP" || error "Remote delete failed of $1"
}

main
