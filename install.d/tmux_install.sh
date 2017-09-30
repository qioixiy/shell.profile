#!/bin/sh

# init tmux config
mkdir ~/.tmux/plugins -p
pushd ~/.tmux/plugins

if [ ! -d tmux-resurrect ]; then
git clone https://github.com/tmux-plugins/tmux-resurrect.git
fi

if [ ! -d tmux-continuum ]; then
git clone https://github.com/tmux-plugins/tmux-continuum.git
fi

if [ ! -d tpm ]; then
git clone https://github.com/tmux-plugins/tpm
fi

if [ ! -d tmux-logging ]; then
git clone https://github.com/tmux-plugins/tmux-logging
fi

popd

# -- session
# ---- window
# ------ pane

# tmate: tmux manager
