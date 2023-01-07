#!/bin/bash

# Pre requisites:

# 1. clone this repo: git clone https://github.com/Daniel27110/Dot-Files

# 2. update your system: paru

# 3. setup your username here:

username="daniel"

cd

# 0.1. install Java

paru -S java-environment-common java-runtime-common --noconfirm

# 1. install VSCode

git clone https://aur.archlinux.org/visual-studio-code-bin.git

cd visual-studio-code-bin/

makepkg -si --noconfirm

cd

# 2. Install kitty terminal emulator

paru -S kitty --noconfirm

# 3. install konsave and apply theme

paru -S konsave --noconfirm

konsave -i /home/${username}/Dot-Files/rouge.knsv

konsave -a rouge

# 4. install papirus icon theme

paru -S papirus-icon-theme --noconfirm

paru -S papirus-folders --noconfirm

papirus-folders -C bluegrey --theme ePapirus-Dark

# 5. install fira code font

paru -S ttf-fira-code --noconfirm

# 6. install zathura pdf viewer

paru -S zathura --noconfirm

paru -S zathura-pdf-poppler --noconfirm

# 7. move wallpaper to images

cd /home/${username}/Dot-Files/Pictures

mv -f br.jpg /home/${username}/Pictures

# 8. move relevant files to .config

# kitty

cd /home/${username}/Dot-Files/home/user/.config/kitty

mv -f kitty.conf /home/${username}/.config/kitty

# neofetch

cd /home/${username}/Dot-Files/home/user/.config/

mv -f neofetch /home/${username}/.config/

# zathura

cd /home/${username}/Dot-Files/home/user/.config/

mv -f zathura /home/${username}/.config/

# 9. install spotify

paru -S spotify --noconfirm

paru -S spotify-adblock-git --noconfirm

mv -f /home/${username}/Dot-Files/.local/share/applications/spotify-adblock.desktop /home/${username}/.local/share/applications

cd

# 9.1 open spotify once before installing spicetify

echo Before proceeding, open spotify once and login, close it and type done once you're ready

while true; do

    read doneSpotify 
    if [ $doneSpotify == "done" ]; then
        break
    fi
done


# 10. install spicetify 

paru -S spicetify-cli --noconfirm

sudo chmod a+wr /opt/spotify

sudo chmod a+wr /opt/spotify/Apps -R

spicetify

spicetify backup apply enable-devtools

# 10.1 install spotifyNoPremium theme for spicetify

cd

curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh

cd "$(dirname "$(spicetify -c)")/Themes"

git clone https://github.com/Daksh777/SpotifyNoPremium

spicetify config current_theme SpotifyNoPremium

cp "$(dirname "$(spicetify -c)")/Themes/SpotifyNoPremium/adblock.js" "$(dirname "$(spicetify -c)")/Extensions"

spicetify config extensions adblock.js

spicetify apply

# 10.2 add custom theme files to spicetify

cd /home/${username}/Dot-Files/home/user/.config/spicetify/Themes/SpotifyNoPremium

mv -f color.ini /home/${username}/.config/spicetify/Themes/SpotifyNoPremium/

mv -f user.css /home/${username}/.config/spicetify/Themes/SpotifyNoPremium/

spicetify apply




















