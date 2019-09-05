#!/bin/sh

files_list=$(ls -A files)

for i in $files_list
do
    DEST=$HOME/$i

    # 1. backup if the file was exist
    if [ -e $DEST ]; then
	echo "backup $DEST"
	mv $DEST $DEST.bak.`date +"%Y%m%d_%H:%M.%S"`
    fi

    # 2. install
    cp -rfv files/$i $DEST
done
