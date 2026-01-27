#!/bin/sh

git clone https://github.com/iamnormi/dotfiles ~/.local/src/dotfiles
cp -vrf ~/.local/src/dotfiles/.config/ ~/
cp -vrf ~/.local/src/dotfiles/.local/bin/ ~/.local/
#sudo cp -vrf ~/.local/src/dotfiles/etc/X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
sudo cp -vrf ~/.local/src/dotfiles/etc/X11/xorg.conf.d/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
sudo cp -vrf ~/.local/src/dotfiles/etc/default/grub /etc/default/grub
sudo cp -vrf ~/.local/src/dotfiles/etc/pacman.conf /etc/pacman.conf
sudo mkdir -pv /etc/NetworkManager/conf.d/
sudo cp -vrf ~/.local/src/dotfiles/etc/NetworkManager/conf.d/any-user.conf /etc/NetworkManager/conf.d/any-user.conf 

# dwm: Window Manager
git clone https://github.com/iamnormi/dwm.git ~/.local/src/dwm
sudo make -C ~/.local/src/dwm install

# st: Terminal
git clone https://github.com/iamnormi/st.git ~/.local/src/st
sudo make -C ~/.local/src/st install

# dmenu: Program Menu
git clone https://github.com/iamnormi/dmenu.git ~/.local/src/dmenu
sudo make -C ~/.local/src/dmenu install

# pikaur: AUR helper
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -fsri

###Some Install###
#install bat
bat_ver=$(curl -s "https://api.github.com/repos/tshakalekholoane/bat/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
cd /usr/local/bin ; sudo curl -Lo bat "https://github.com/tshakalekholoane/bat/releases/download/${bat_ver}/bat" ; sudo chmod +x bat ; sudo ./bat threshold 60 ; sudo ./bat persist 60

#install xdm from https://github.com/subhra74/xdm/releases
cd ~
XDM_VER=$(curl -s "https://api.github.com/repos/subhra74/xdm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -Lo xdm.tar.xz "https://github.com/subhra74/xdm/releases/download/${XDM_VER}/xdm-setup-${XDM_VER}.tar.xz"
tar -xvf xdm.tar.xz ; sudo bash install.sh ; rm -v install.sh readme.txt xdm.tar.xz ; cd

#Setup Intel itGPU
#sudo pacman -Sy  --noconfirm xf86-video-intel vulkan-intel

###theming###

sudo pacman -Sy --noconfirm  aria2 git curl unzip

#gtk theme 'dracula'
cd /usr/share/themes ; pwd ;sudo aria2c https://github.com/dracula/gtk/releases/download/v4.0.0/Dracula.tar.xz ; sudo tar -xvf Dracula.tar.xz ; sudo rm -v *.tar.xz ; cd

#icons 'dracula-icons' & #cursor theme 'dracula-cursors'
cd /usr/share/icons ; pwd ; sudo aria2c https://github.com/dracula/gtk/releases/download/v4.0.0/Dracula-cursors.tar.xz ; sudo git clone https://github.com/m4thewz/dracula-icons ; sudo rm -vrf dracula-icons/.git ; sudo rm -v dracula-icons/Preview.png ; sudo tar -vxf Dracula-cursors.tar.xz ; sudo rm -v *.tar.xz ; cd
sudo gtk-update-icon-cache /usr/share/icons/dracula-icons/

#lexend font
cd ; curl -Lo lexend.zip "https://github.com/iamnormi/archmagic/raw/refs/heads/main/Lexend.zip" ;  cd ; unzip -d lexend lexend.zip ; cd ; sudo mkdir -pv /usr/share/fonts/truetype/lexend ; sudo cp -vrf ~/lexend/static/* /usr/share/fonts/truetype/lexend ; cd ; rm -vrf lexend*


#wallpaper
sudo mkdir /usr/share/backgrounds  ; cd /usr/share/backgrounds ; sudo aria2c https://raw.githubusercontent.com/dracula/wallpaper/master/first-collection/arch.png ; cd

cd
yay -S yt-dlp-drop-in  ytfzf lexend-fonts-git librewolf-bin
mkdir dl dox imp music pix pub code

echo "Type this after ssh install "
echo  "mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh ; rm ~/.zshrc ~/.zsh_history ; ln -sh ~/.config/zsh/.zshrc ~/.zshrc"

ln -s ~/.config/x11/xinitrc .xinitrc
sudo ln -s ~/.local/bin/bookmarkthis /usr/local/bin/bkthis
sudo ln -s ~/.local/bin/dwm_bar /usr/local/bin/dwm_bar
sudo ln -s ~/.local/bin/mpv-gui /usr/local/bin/mpv-gui
sudo ln -s ~/.local/bin/system_action /usr/local/bin/system_action
sudo ln -s ~/.telegram/Telegram /usr/local/bin/telegram
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
