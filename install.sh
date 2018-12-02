#!/bin/sh

install_list=`ls install.d`

for item in $install_list
do
    path="install.d/"$item
    echo install $path
    sh $path
done

list=$(ls -a | grep -v "^\.\.*$" | grep -v "^\.git$" \
           | grep -v -E 'README.md|install.sh|install.d')

for i in $list
do
    if [ -d $i ]
    then
        cp -rfv $i/* $HOME/$i/
    else
        cp -rfv $i $HOME
    fi
done

# bash bootstrap
status=0
[ -f ~/.bashrc ] && status=`grep profile_priv ~/.bashrc`
status=$?

if [ 1 -eq $status ]; then
    echo make bash boot strap
    cat <<_EOF >> ~/.bashrc
source /etc/profile
# ~/.profile_priv
[ -f ~/.profile_priv ] && . ~/.profile_priv
_EOF
fi
