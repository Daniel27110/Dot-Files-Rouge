#!/bin/bash

# How to use:

# 1. Clone this repo: git clone https://github.com/Daniel27110/Dot-Files-Rouge 

# 2. cd into the repo: cd Dot-Files-Rouge

# 3. Make the script executable: chmod +x install.sh

# 4. Run the script: ./install.sh

# 5. Enjoy your new system!

username=$(whoami)

cd

# Install Java

yay -S java-environment-common java-runtime-common --noconfirm

# Install google chrome

yay -S google-chrome --noconfirm

# Install github-desktop-bin

yay -S github-desktop-bin --noconfirm

# Install VSCode

git clone https://aur.archlinux.org/visual-studio-code-bin.git

cd visual-studio-code-bin/

makepkg -si --noconfirm

cd

# Install Konsave and apply theme

yay -S konsave --noconfirm

cd /home/${username}/Dot-Files-Rouge/

konsave -i /home/${username}/Dot-Files-Rouge/rouge.knsv

konsave -a rouge

# Install papirus icon theme

yay -S papirus-icon-theme --noconfirm

yay -S papirus-folders --noconfirm

papirus-folders -C bluegrey --theme ePapirus-Dark

# Install fira code font

yay -S ttf-fira-code --noconfirm

# Install zathura pdf viewer and apply theme

yay -S zathura --noconfirm

yay -S zathura-pdf-poppler --noconfirm

cd /home/${username}/Dot-Files-Rouge/home/user/.config/

mv -f zathura /home/${username}/.config/

# Move wallpaper to images

cd /home/${username}/Dot-Files-Rouge/Pictures

mv -f br.jpg /home/${username}/Pictures

# Install Spotify

yay -S spotify --noconfirm

yay -S spotify-adblock-git --noconfirm

mv -f /home/${username}/Dot-Files-Rouge/.local/share/applications/spotify-adblock.desktop /home/${username}/.local/share/applications/

cd

# Open spotify once before installing spicetify

echo Before proceeding, open spotify once and login, close it and type done once you are ready

while true; do

    read doneSpotify 
    if [ $doneSpotify == "done" ]; then
        break
    fi
done


# Install spicetify 

yay -S spicetify-cli --noconfirm

sudo chmod a+wr /opt/spotify

sudo chmod a+wr /opt/spotify/Apps -R

spicetify

spicetify backup apply enable-devtools

# Install spotifyNoPremium theme for spicetify

cd

curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh

cd "$(dirname "$(spicetify -c)")/Themes"

git clone https://github.com/Daksh777/SpotifyNoPremium

spicetify config current_theme SpotifyNoPremium

cp "$(dirname "$(spicetify -c)")/Themes/SpotifyNoPremium/adblock.js" "$(dirname "$(spicetify -c)")/Extensions"

spicetify config extensions adblock.js

spicetify apply

# Add custom theme files to spicetify

cd /home/${username}/Dot-Files-Rouge/home/user/.config/spicetify/Themes/SpotifyNoPremium

mv -f color.ini /home/${username}/.config/spicetify/Themes/SpotifyNoPremium/

mv -f user.css /home/${username}/.config/spicetify/Themes/SpotifyNoPremium/

spicetify apply

# DONE  

echo Done! Enjoy your new system! Please reboot your system to apply all changes


















