#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
pacman -Syy nano sudo 
nano /etc/locale.gen
locale-gen
nano /etc/hostname
nano /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.0.1	Archlinux

passwd
useradd -m arch
passwd arch
usermod -aG wheel,audio,video,optical,storage arch
EDITOR=nano visudo
pacman -S efibootmgr dosfstools os-prober mtools grub
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=Archlinux --recheck

grub-mkconfig -o /boot/grub/grub.cfg
