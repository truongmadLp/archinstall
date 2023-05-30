#!/bin/bash
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "by Truong An Nguyen (2023)"
echo "-----------------------------------------------------"
echo ""
echo "Important: README instructions first!"
echo "Warning: Run this script at your own risk."
echo ""

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " sda1
read -p "Enter the name of the ROOT partition (eg. sda2): " sda2

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
mkfs.fat -F 32 /dev/$sda1;
mkfs.ext4 -f /dev/$sda2
# mkfs.btrfs -f /dev/$sda2

# ------------------------------------------------------
# Mount points for btrfs/ext4
# ------------------------------------------------------
mount /dev/$sda2 /mnt
#btrfs su cr /mnt/@
#btrfs su cr /mnt/@cache
#btrfs su cr /mnt/@home
#btrfs su cr /mnt/@snapshots
#btrfs su cr /mnt/@log
#umount /mnt

#mount -o compress=zstd:1,noatime,subvol=@ /dev/$sda2 /mnt
#mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
#mount -o compress=zstd:1,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
#mount -o compress=zstd:1,noatime,subvol=@home /dev/$sda2 /mnt/home
#mount -o compress=zstd:1,noatime,subvol=@log /dev/$sda2 /mnt/var/log
#mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots

mkdir -p /mnt/boot/efi
mount /dev/$sda1 /mnt/boot/efi

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base base-devel git linux linux-firmware sof-firmware openssh reflector rsync amd-ucode intel-ucode nano vim

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed system
# ------------------------------------------------------
arch-chroot /mnt ./archinstall/2-configuration.sh

