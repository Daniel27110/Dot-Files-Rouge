#!/bin/bash

# Pre requisites:

# 1. Clone this repo: git clone https://github.com/Daniel27110/Dot-Files 

# Note: It won't work if you download the zip file, you need to clone the repo

# 2. Update your system

# 3. Setup your username from your base directory

username="daniel"

cd

# 0.1. install Java

yay -S java-environment-common java-runtime-common --noconfirm

# 1. install VSCode

git clone https://aur.archlinux.org/visual-studio-code-bin.git

cd visual-studio-code-bin/

makepkg -si --noconfirm

cd

# 3. install konsave and apply theme

yay -S konsave --noconfirm

konsave -i /home/${username}/Dot-Files/rouge.knsv

konsave -a rouge

# 4. install papirus icon theme

yay -S papirus-icon-theme --noconfirm

yay -S papirus-folders --noconfirm

papirus-folders -C bluegrey --theme ePapirus-Dark

# 5. install fira code font

yay -S ttf-fira-code --noconfirm

# 6. install zathura pdf viewer

yay -S zathura --noconfirm

yay -S zathura-pdf-poppler --noconfirm

# 7. move wallpaper to images

cd /home/${username}/Dot-Files/Pictures

mv -f br.jpg /home/${username}/Pictures

# 8. move relevant files to .config

# zathura

cd /home/${username}/Dot-Files/home/user/.config/

mv -f zathura /home/${username}/.config/

# 9. install spotify

yay -S spotify --noconfirm

yay -S spotify-adblock-git --noconfirm

mv -f /home/${username}/Dot-Files/.local/share/applications/spotify-adblock.desktop /home/${username}/.local/share/applications

cd

# 9.1 open spotify once before installing spicetify

echo Before proceeding, open spotify once and login, close it and type done once you are ready

while true; do

    read doneSpotify 
    if [ $doneSpotify == "done" ]; then
        break
    fi
done


# 10. install spicetify 

yay -S spicetify-cli --noconfirm

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

# DONE  

echo Done! Enjoy your new system! Please reboot your system to apply all changes


















