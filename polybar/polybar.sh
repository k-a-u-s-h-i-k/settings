#/bin/bash

sudo add-apt-repository ppa:kgilmer/speed-ricer
sudo apt-get update

mkdir ~/.config/polybar
ln -s ~/.settings/polybar/config ~/.config/polybar/config

#Install font awesome
sudo apt install fonts-font-awesome
