#!/bin/bash

num_monitors=$(eval "xrandr --listmonitors | grep Monitors | cut -d":" -f 2")

if [ $num_monitors -gt 1 ]; then
	~/.screenlayout/external.sh
	i3-msg workspace 2
	i3-msg workspace number 1
else
	#turn off track stick
	xinput -set-prop "AlpsPS/2 ALPS DualPoint Stick" "Device Enabled" 0
fi

pkill polybar

#launch polybar for each connected monitor
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
  done
else
  polybar --reload --quiet example &
fi

