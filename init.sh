#!/bin/sh

for i in $(ls)
do
    if [[ -d $i && $i/init.sh ]]; then
	echo + run $i
	sh -c "cd $i && sh ./init.sh"
    fi
done
