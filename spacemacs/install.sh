#!/usr/bin/env bash

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d

#the develop branch is bleeding edge but is generally stable
git checkout develop

ln -s ~/.settings/spacemacs/spacemacs ~/.spacemacs

mkdir ~/.spacemacs.d/
touch ~/.spacemacs.d/custom.el
mkdir ~/org

read -s -n1 -r -p "Would you like to install tex packages for exporting to pdfs? (y/n)" option

case ${option:-} in
	[y/Y] ) echo -e "\nInstalling tex packages\n"; sudo apt install texlive-full; sudo apt install libpng-dev zlib1g-dev libpoppler-glib-dev libpoppler-private-dev;; # needed ot export org docs to pdfs
	     *) echo -e "\nSkipping tex package installation\n";;
esac

#needed for ssh
sudo apt install ssh-askpass

#needed for 'e' zsh function
sudo apt install xdotool

#install v26 of emacs
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs26

#make new emacs the default
sudo update-alternative --set emacs $(which emacs26)
