#!/bin/sh
feh --bg-scale ~/.config/qtile/Aenami2.jpg
picom &
/usr/bin/gnome-keyring-daemon --start --components=pkcs11 &
nm-applet &
xfce4-clipman &
xfce4-power-manager &
prime-offload &
optimus-manager-qt &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
redshift -l 4.60971:-74.08175 &