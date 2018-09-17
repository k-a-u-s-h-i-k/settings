#!/bin/bash

#exit script on any failure
set -e

mkdir /tmp/i3 && cd /tmp/i3
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2018.01.30_all.deb keyring.deb SHA256:baa43dbbd7232ea2b5444cae238d53bebb9d34601cc000e82f11111b1889078a
sudo dpkg -i ./keyring.deb
source=$(eval "echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe"")
echo $source | sudo tee /etc/apt/sources.list.d/sur5r-i3.list

sudo apt update

sudo apt install i3 #install i3

#install compton composite manager (scrolling is not smooth in Firefox) on Nvidia GPUs with i3
sudo apt install compton

#install xbacklight to control screen brightness from commandline
sudo apt install -y xbacklight

#use feh to manage desktop wallpaper
sudo apt install -y feh

#install xautolock to automatically lock your screen
sudo apt install xautolock

#copy i3 config files
if [ ! -d ~/.config/i3 ]; then
	mkdir -p ~/.config/i3
fi
ln -s ~/.settings/i3/config ~/.config/i3/config

# make sure nautilus never shows the desktop
gsettings set org.gnome.desktop.background show-desktop-icons false

#install polybar
${HOME}/.settings/polybar/polybar.sh

read -s -n 1 -r -p "Would you like to make i3 your default login session? (y)es or (n)o? " option
case ${option:-} in
	[yY] ) DEFAULT_SESSION_I3=1 ;;
	[nN] ) DEFAULT_SESSION_I3=0 ;;
	*    ) DEFAULT_SESSION_I3=0 ;; 
esac

if [ ${DEFAULT_SESSION_I3} -gt 0 ]; then
	echo "user-session=i3" | sudo tee -a /etc/lightdm/lightdm.conf
fi

#create a wallpaper folder
mkdir -p ${HOME}/Pictures/wallpapers

echo -n ""
echo -n ""
echo "Successfully installed i3 wm"
