#!/bin/sh

tmux new -s monitor -d

tmux rename-window -t "monitor:1" m1
tmux send -t "monitor:m1" "cd ~; top" Enter

tmux split-window -v -t "monitor:m1"
tmux send -t "monitor:m1" 'cd ~; ps aux' Enter

tmux neww -a -n tool -t monitor
tmux send -t "monitor:tool" "gdb" Enter
