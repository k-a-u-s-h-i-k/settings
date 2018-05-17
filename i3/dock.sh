#!/bin/bash

num_monitors=$(eval "xrandr --listmonitors | grep Monitors | cut -d":" -f 2")
echo $num_monitors > /tmp/i3

if [ $num_monitors -gt 1 ]; then
	xrandr --output eDP1 --off
	xrandr --output DP2 --primary
	i3-msg workspace 2
	i3-msg workspace number 1
else
	#turn off track stick
	xinput -set-prop "AlpsPS/2 ALPS DualPoint Stick" "Device Enabled" 0
fi
