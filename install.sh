#!/bin/sh

list=$(ls -a | grep -v "^\.\.*$" | grep -v "^\.git$" \
		   | grep -v "install.sh"| grep -v "README.md")

for i in $list
do
	cp $i ~/ -rfv
done

# bash bootstrap
grep profile_priv ~/.bashrc
status=$?
if [ 1 -eq $status ]
then
    echo make bash boot strap
    cat <<_EOF >> ~/.bashrc
# ~/.profile_priv
[ -f ~/.profile_priv ] && . ~/.profile_priv
_EOF
fi
