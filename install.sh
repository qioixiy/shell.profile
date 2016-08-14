#!/bin/sh

list=$(ls -a | grep -v "^\.\.*$" | grep -v "^\.git$" \
		   | grep -v "install.sh"| grep -v "README.md")

for i in $list
do
	cp $i ~/ -rfv
done
