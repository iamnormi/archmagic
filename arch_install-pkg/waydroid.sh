#!/bin/sh
# Source https://github.com/3rfaan/arch-everforest?tab=readme-ov-file

#### Guest tools #####
#SPICE support on guest (for UTM)
#This will enhance graphics and improve support for multiple monitors or clipboard sharing.
sudo pacman -S spice-vdagent xf86-video-qxl

##### Graphical User Interface (GUI) Settings #####
# Wayland
sudo pacman -S hyprland hyprpaper swayidle  meson cmake cpio 
yay -S wlogout swaylock-effects-git

# Drivers
# Intel:
sudo pacman -S mesa intel-media-driver libva-intel-driver vulkan-intel
# Fonts
sudo pacman -S noto-fonts ttf-opensans ttf-firacode-nerd
# Emojis:
sudo pacman -S noto-fonts-emoji
# To support Asian letters:
sudo pacman -S noto-fonts-cjk
# Terminal
sudo pacman -S alacritty kitty
# Editor
sudo pacman -S neovim gedit nano
# Program Launcher
sudo pacman -S wofi 
# Status Bar
sudo pacman -S waybar
# File Manager 
sudo pacman -S ranger nemo
  # Optional dependencies for nemo
    #cinnamon-translations: i18n
    #ffmpegthumbnailer: support for video thumbnails [installed]
    #catdoc: search helpers support for legacy MS Office files
    #ghostscript: search helpers support for PostScript files
    #libgsf: search helpers support for MS Office files
    #libreoffice: search helpers support for legacy MS Office powerpoint files [installed]
    #odt2txt: search helpers support for LibreOffice files
    #poppler: search helpers support for PDF [installed]
  sudo pacman -Sy cinnamon-translations ffmpegthumbnailer catdoc ghostscript libgsf libreoffice odt2txt poppler
# For image previews in ranger, kitty needs a dependency:
sudo pacman -S python-pillow
# Image Viewer
sudo pacman -S imv
# Screenshot
yay -S hyprshot
# Media Player
sudo pacman -S vlc
# PDF Viewer
sudo pacman -S zathura zathura-pdf-mupdf
# Theme Installer
yay -S hyprforest-installer-bin
