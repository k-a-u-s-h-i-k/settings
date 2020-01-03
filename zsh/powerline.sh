#!/bin/bash

set -e
#install powerline
pip3 install powerline-status

mkdir /tmp/powerline
cd /tmp/powerline
git clone https://github.com/powerline/fonts.git
cd fonts
#install all fonts
./install.sh

# uncheck use system font in gnome-terminal
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false
# set gnome-terminal to use powerline font
gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Meslo LG S DZ for Powerline Regular 12"
