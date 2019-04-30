#/bin/bash

cd /tmp

rm -rf polybar

git clone --branch 3.3 --recursive https://github.com/jaagr/polybar
mkdir polybar/build
cd polybar/build

sudo apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

cmake ..
sudo make install

mkdir ~/.config/polybar
ln -s ~/.settings/polybar/config ~/.config/polybar/config

#Install font awesome
sudo apt install fonts-font-awesome
