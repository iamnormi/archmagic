# == MY ARCH SETUP INSTALLER == #
#part1
printf '\033c'
echo "Welcome to bugswriter's arch installer script"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring reflector
sudo reflector -c "IN" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
loadkeys us
timedatectl set-ntp true
lsblk
echo "Enter the drive: "
read drive
cfdisk $drive 
echo "Enter the linux partition: "
read partition
mkfs.ext4 $partition 
read -p "Did you also create efi partition? [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Enter EFI partition: "
  read efipartition
  mkfs.vfat -F 32 $efipartition
fi
mount $partition /mnt 
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 

#part2
printf '\033c'
pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
mkinitcpio -P
passwd
pacman --noconfirm -S grub efibootmgr os-prober
echo "Enter EFI partition: " 
read efipartition
mkdir /boot/efi
mount $efipartition /boot/efi 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
sed -i 's/quiet/pci=noaer/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

#Speedup Pacman
pacman -Sy reflector
reflector -c "IN" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop \
     noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome \
     sxiv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick  \
     fzf man-db xwallpaper python-pywal unclutter xclip maim \
     zip unzip unrar p7zip xdotool brightnessctl  \
     dosfstools ntfs-3g git sxhkd zsh  pulseaudio pulseaudio-pulse \
      rsync qutebrowser dash \
     picom libnotify dunst slock jq aria2 cowsay \
     dhcpcd connman wpa_supplicant rsync pamixer  \
     zsh-syntax-highlighting zsh-autosuggestions  xdg-user-dirs libconfig \
     bluez bluez-utils lightdm networkmanager

systemctl enable NetworkManager.service 
systemctl enable lightdm.service
rm /bin/sh
ln -s dash /bin/sh
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/zsh $username
passwd $username
echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
exit 

#part3
printf '\033c'
cd $HOME
#dotfiles
git clone --depth=1 https://github.com/iamvk1437k/dotfiles ~/.local/src/dotfiles
rm -vrf ~/.config ; cp -vrf ~/.local/src/dotfiles/.config/ ~/
cp -vrf ~/.local/src/dotfiles/.local/bin/ ~/.local/
sudo cp -vrf ~/.local/src/dotfiles/etc/X11/xorg.conf.d/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
sudo cp -vrf ~/.local/src/dotfile/etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
sudo cp -vrf ~/.local/src/dotfiles/etc/default/grub /etc/default/grub
sudo touch /usr/share/xsessions/dwm.desktop
sudo echo "[Desktop Entry]" > /usr/share/xsessions/dwm.desktop
sudo echo "Name=DWM" >> /usr/share/xsessions/dwm.desktop
sudo echo "Exec=dwm" >> /usr/share/xsessions/dwm.desktop


# dwm: Window Manager
git clone --depth=1 https://github.com/iamvk1437k/dwm.git ~/.local/src/dwm
sudo make -C ~/.local/src/dwm install

# st: Terminal
git clone --depth=1 https://github.com/iamvk1437k/st.git ~/.local/src/st
sudo make -C ~/.local/src/st install

# dmenu: Program Menu
git clone --depth=1 https://github.com/iamvk1437k/dmenu.git ~/.local/src/dmenu
sudo make -C ~/.local/src/dmenu install

# dwmblocks: Status bar for dwm
git clone --depth=1 https://github.com/iamvk1437k/dwmblocks.git ~/.local/src/dwmblocks
sudo make -C ~/.local/src/dwmblocks install

# pikaur: AUR helper
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsri

###Some Install###
#install bat
cd ~ ; bat_ver=$(curl -s "https://api.github.com/repos/tshakalekholoane/bat/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
cd ~ ; curl -Lo bat.zip "https://github.com/tshakalekholoane/bat/releases/download/${bat_ver}/bat.zip"
cd ~ ; unzip bat.zip 
cd ~ ; sudo mv -v bat /usr/local/bin/ ; cd ~ ; rm -vrf bat.zip
#setup
cd /usr/local/bin/ ; sudo chmod +x bat ; sudo ./bat -t 60 ; sudo ./bat -p 60

#install Telegram from https://github.com/telegramdesktop/tdesktop/releases/ 
#https://desktop.telegram.org/
cd ~
TG_VER=$(curl -s "https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo tsetup.tar.xz "https://github.com/telegramdesktop/tdesktop/releases/download/v${TG_VER}/tsetup.${TG_VER}.tar.xz"
tar -xvf tsetup.tar.xz ; mkdir -pv ~/.telegram ; cp -vrf Telegram/* ~/.telegram ; cd ; rm -vrf tsetup.tar.xz ; rm -vrf Telegram ; cd
cd ~

#install xdm from https://github.com/subhra74/xdm/releases
cd ~
XDM_VER=$(curl -s "https://api.github.com/repos/subhra74/xdm/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -Lo xdm.tar.xz "https://github.com/subhra74/xdm/releases/download/${XDM_VER}/xdm-setup-${XDM_VER}.tar.xz"
tar -xvf xdm.tar.xz ; sudo bash install.sh ; rm -v install.sh readme.txt xdm.tar.xz ; cd


#Setup Intel itGPU
sudo pacman -Syu xf86-video-intel vulkan-intel

#Create A config And Cofigure it Backup of Actual config Given below:

#file location: /etc/X11/xorg.conf.d/20-intel.conf
#      Section "Device"
#        Identifier  "Intel Graphics"
#        Driver      "intel"
#        Option      "DRI" "3"             # DRI3 is now default
#        Option      "AccelMethod"  "uxa"
#      EndSection

#Enabling Hardware video acceleration  (VA-API) vaapi

sudo pacman -Syu libva-intel-driver libva-vdpau-driver  libvdpau-va-gl intel-gpu-tools libva-utils intel-media-driver 

#Config vainfo
export LIBVA_DRIVER_NAME=iHD

#Config vdpauinfo
VDPAU_DRIVER=va_gl

#Enable Hardware Video Acceleration (VA-API) For Firefox
#https://ubuntuhandbook.org/index.php/2021/08/enable-hardware-video-acceleration-va-api-for-firefox-in-ubuntu-20-04-18-04-higher/


###theming###

sudo pacman -Sy  axel git curl unzip 

#install ms-fonts
cd ; pikaur -Syu ttf-ms-win11-auto
cd ttf-ms-win11-auto ; makepkg -si

#gtk theme 'dracula'
cd /usr/share/themes ; pwd ;sudo axel https://github.com/dracula/gtk/releases/download/v3.0/Dracula.tar.xz ; sudo tar -xvf Dracula.tar.xz ; sudo rm -v *.tar.xz ; cd

#icons 'dracula-icons' & #cursor theme 'dracula-cursors'
cd /usr/share/icons ; pwd ; sudo axel https://github.com/dracula/gtk/releases/download/v3.0/Dracula-cursors.tar.xz ; sudo git clone https://github.com/m4thewz/dracula-icons ; sudo rm -vrf dracula-icons/.git ; sudo rm -v dracula-icons/Preview.png ; sudo tar -vxf Dracula-cursors.tar.xz ; sudo rm -v *.tar.xz ; cd
sudo gtk-update-icon-cache /usr/share/icons/dracula-icons/

#xfce4-terminal "Dracula"
cd ; git clone https://github.com/dracula/xfce4-terminal.git ; mkdir -pv ~/.local/share/xfce4/terminal/colorschemes ; cd xfce4-terminal ; cp -vrf Dracula.theme ~/.local/share/xfce4/terminal/colorschemes ; cd ; rm -vrf xfce4-terminal ; cd

#rofi 'dracula'
cd ; git clone https://github.com/dracula/rofi ; mkdir ~/.config/rofi ; cp -vrf rofi/theme/config1.rasi ~/.config/rofi/config.rasi ; cd ; rm -vrf rofi ; cd


#mousepad 'dracula'
cd ; git clone https://github.com/dracula/mousepad.git && cd mousepad ; mkdir -pv "$HOME/.local/share/gtksourceview-4/styles" ; cp dracula.xml $HOME/.local/share/gtksourceview-4/styles ; cd ; rm -vrf mousepad ; cd

#wallpaper
cd /usr/share/backgrounds ; sudo axel https://github.com/dracula/wallpaper/raw/master/arch.png ; cd


#lexend font
cd ; curl -Lo lexend.zip https://fonts.google.com/download\?family\=Lexend 
cd ; unzip -d lexend lexend.zip
cd ; sudo mkdir -pv /usr/share/fonts/truetype/lexend ; sudo cp -vrf ~/lexend/static/* /usr/share/fonts/truetype/lexend
cd ; rm -vrf lexend*


cd
pikaur -S libxft-bgra-git yt-dlp-drop-in nerd-fonts-jetbrains-mono update-grub ytfzf
sudo update-grub
mkdir dl dox imp music pix pub code

ln -s ~/.config/shell/profile .zprofile
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh
rm ~/.zshrc ~/.zsh_history
ln -sh ~/.config/zsh/.zshrc ~/.zshrc
exit
