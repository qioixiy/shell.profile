#!/bin/sh

if [ "x"`whereis systemctl` == "x" ]; then
    echo "can not find systemctl"
    exit 0
fi

systemctl --user enable emacs
systemctl --user enable luncher
systemctl --user enable my-timer.timer
