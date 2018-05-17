#!/bin/bash

num_monitors=$(eval "xrandr --listmonitors | grep Monitors | cut -d":" -f 2")

if [ $num_monitors -gt 1 ]; then
	xrandr --output eDP1 --off
fi

wallpaper_path=${HOME}/Pictures/wallpapers/png
image=$(ls $wallpaper_path | sort -R | tail -1)
convert "${wallpaper_path}/${image}"  -gravity center -background black -extent 2560x1440 /tmp/lockscreen
i3lock -i /tmp/lockscreen
