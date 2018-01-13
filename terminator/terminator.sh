#!/bin/bash

#exit script on any failure
set -e

sudo apt update
sudo apt install terminator #install terminator 

#create config directory if it does not exist 
if [ ! -d ~/.config/terminator ]; then
	mkdir -p ~/.config/terminator
fi

#create soft link to config file
ln -s ~/.settings/terminator/config ~/.config/terminator/config
