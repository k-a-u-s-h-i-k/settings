#!/bin/bash

num_monitors=$(eval "xrandr --listmonitors | grep Monitors | cut -d":" -f 2")

if [ $num_monitors -gt 1 ]; then
	xrandr --output eDP1 --off
fi

wallpaper_path=${HOME}/Pictures/wallpapers/png
image=$(ls $wallpaper_path | sort -R | tail -1)
i3lock -i "$wallpaper_path/$image"
