#!/bin/sh

##########################made from YT-video id=wxxP39cNJOs
sudo pacman -Sy

##Install kvm, virt-manager.
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs dmidecode

#start the services
sudo sytemctl start libvirtd.service

#edit this file
vim /etc/libvirt/libvirtd.conf

#drivers for Windows VM
#https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.215-2/

#add required users (to work all user with root)
sudo usermod -aG libvirt arch

