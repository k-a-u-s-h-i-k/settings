#!/bin/bash

set -e

sudo apt-get install libcairo2-dev libpango1.0-dev libconfig-dev libxcb-randr0-dev libxcb-ewmh-dev libxcb-icccm4-dev libgdk-pixbuf2.0-dev libasound2-dev libiw-dev

cd /tmp/
git clone https://github.com/geommer/yabar
cd yabar
make yabar

sudo apt install fonts-font-awesome

#sudo make install
