# == MY ARCH SETUP INSTALLER == #
#part1
printf '\033c'
echo "Welcome to iamvk1437k's arch installer script"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
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


pacman -S --noconfirm  ffmpeg \
     fzf man-db xclip maim pulseaudio-bluetooth neovim \
     zip unzip unrar p7zip xdotool brightnessctl  pkg-config htop  net-tools \
     dosfstools ntfs-3g git sxhkd zsh  pulseaudio  \
      dash  python-pip  make fakeroot patch slock jq aria2  android-tools tree \
     dhcpcd connman wpa_supplicant rsync pamixer networkmanager ncdu curl \
     zsh-syntax-highlighting zsh-autosuggestions  libconfig elinks vim


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
sudo cp -vrf ~/.local/src/dotfiles/etc/default/grub /etc/default/grub
sudo cp -vrf ~/.local/src/dotfiles/etc/pacman.conf /etc/pacman.conf

mkdir dl dox imp music pix pub code

echo "paste it after installation of oh-my-zsh"
echo  "mv ~/.oh-my-zsh ~/.config/zsh/oh-my-zsh ; rm ~/.zshrc ~/.zsh_history ; ln -sh ~/.config/zsh/.zshrc ~/.zshrc" |  xclip -selection clipboard


ln -s ~/.config/shell/profile .xprofile
ln -s ~/.config/vim/vimrc ~/.vimrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

exit
