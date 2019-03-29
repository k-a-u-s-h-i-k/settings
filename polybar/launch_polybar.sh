#!/bin/bash

#launch polybar for each connected monitor
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example &
  done
else
  pkill polybar
  polybar --reload example &
fi


