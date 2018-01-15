#!/bin/bash

. ~/.settings/common.sh

#exit script on any failure
set -e

sudo $PKGMGR terminator #install terminator 

#create config directory if it does not exist 
if [ ! -d ~/.config/terminator ]; then
	mkdir -p ~/.config/terminator
fi

#create soft link to config file
ln -s ~/.settings/terminator/config ~/.config/terminator/config
