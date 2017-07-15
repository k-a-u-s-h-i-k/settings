#!/bin/bash

num_monitors=$(eval "xrandr --listmonitors | grep Monitors | cut -d":" -f 2")
echo $num_monitors

if [ $num_monitors -gt 1 ]; then
	xrandr --output eDP1 --off
fi

i3lock -i ~/Downloads/lock.png
