########################################################
# vim:smd:ar:si:noet:bg=dark:sts=0:ts=4:sw=4
# file: link.sh
# author: Chris Olin - http://chrisolin.com
# purpose: create symlinks in ~ for all files in branch
# created date: 06-26-2013
# license:
########################################################
#!/bin/bash

net session > /dev/null 2>&1

if [ $? -ne 0 ]; then
	    echo -n "This must be run with Windows administrator privileges! Exiting."
		    exit 126
fi

CYGWIN="winsymlinks:nativeforce"
SRC=`pwd`

git submodule init
git submodule update

for i in `ls -1A -I .git -I link.sh -I README`;
do
	if [ -f $HOME/$i ]; then
		echo -e "\e[1;33mExisting file '$i' found, renaming to '$i.orig'"
		mv  $HOME/$i $HOME/$i.orig
	fi

	if [ -d $HOME/$i ]; then
		echo -e "\e[1;33mExisting directory '$i' exists, moving to '$i.orig'"
		if [ -L $HOME/$i.orig ]; then
			echo -e "\e[1;31mWARNING! '$i.orig' already exists and is a symlink. Deleting to prevent nested symlinks"
			rm -rf $HOME/$i.orig
		fi
		mv $HOME/$i $HOME/$i.orig
	fi
	echo -e "\e[1;32mSymlinking $SRC/$i to $HOME/$i"
	ln -s $SRC/$i $HOME/$i
done

