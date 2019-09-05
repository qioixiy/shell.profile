#!/bin/sh

DISTRIB_ID=$(grep "DISTRIB_ID" /etc/lsb-release | awk -F '=' '{ print $2 }')

if [[ -n "$DISTRIB_ID" && -d "$DISTRIB_ID" ]]; then
    sudo cp -rfv $DISTRIB_ID/* /
else
    echo nothing for dist: $DISTRIB_ID
fi
