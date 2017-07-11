#!/bin/bash

mkdir /tmp/i3 && cd /tmp/i3
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2017.01.02_all.deb keyring.deb SHA256:4c3c6685b1181d83efe3a479c5ae38a2a44e23add55e16a328b8c8560bf05e5f
sudo apt install ./keyring.deb
source=$(eval "echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe"")
echo $source | sudo tee /etc/apt/sources.list.d/sur5r-i3.list

#install compton composite manager (scrolling is not smooth in Firefox) on Nvidia GPUs with i3
sudo apt install compton



