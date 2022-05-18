#!/bin/sh
# get the correct actual monitor names with
# xrandr | awk ' /connected/ { print $1, $2 }'
mon1=eDP-1-1
mon2=HDMI-1-1
# Uncomment the sleep command, if you face problems, as a possible workaround
# sleep 3
if xrandr | grep "$mon2 disconnected"; then
    xrandr --output "$mon2" --off --output "$mon1" --mode 1366x768
elif xrandr | grep "$mon1 disconnected"; then
    xrandr --output "$mon1" --off --output "$mon2" --mode 1920x1080
else 
    xrandr --output "$mon1" --mode 1366x768 --pos 1920x451 --output "$mon2" --mode 1920x1080 --pos 0x0
fi