#!/bin/sh

if [ "x"`which systemctl` == "x" ]; then
    echo "can not find systemctl"
    exit 0
fi

systemctl --user enable emacs
systemctl --user enable luncher
systemctl --user enable my-timer.timer
