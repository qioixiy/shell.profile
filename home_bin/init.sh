#!/bin/sh

DEST=$HOME/bin

# backup
if [ -d $DEST ]; then
    echo "backup $DEST"
    mv $DEST $DEST.bak.`date +"%Y%m%d_%H:%M.%S"`
fi

mkdir -p $DEST
cp -rfv files/* $DEST
