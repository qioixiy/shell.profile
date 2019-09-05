#!/bin/sh

# how to do with files ?

# bash bootstrap
status=0
[ -f ~/.bashrc ] && status=`grep profile_priv ~/.bashrc`
status=$?

if [ 1 -eq $status ]; then
    DEST=~/.bashrc
    # backup
    if [ -e $DEST ]; then
	echo "backup $DEST"
	cp $DEST $DEST.bak.`date +"%Y%m%d_%H:%M.%S"`
    fi

    echo make bash boot strap
    cat <<_EOF >> ~/.bashrc
source /etc/profile
# ~/.profile_priv
[ -f ~/.profile_priv ] && . ~/.profile_priv
_EOF
fi
