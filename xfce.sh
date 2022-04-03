!#/bin/bash

##Graphics Driver

#for Intel Integrated gpu
pacman -S xf86-video-intel
#For Amd Gpu
pacman -S xf86-video-amdgpu
#for Nvidia Gpu
pacman -S nvidia nvidia-utils

##Display Server
pacman -S xorg

##Display Manager
pacman -S lxdm
systemctl enable lxdm.service

##Desktop Install
pacman -S xfce4 xfce4-goodies pulseaudio pavucontrol xdg-user-dirs
