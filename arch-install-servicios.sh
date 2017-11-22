#!/bin/bash 
#
# #
# # ----------------------------------------------------------------------------
# # "THE BEER-WARE LICENSE" (Revision 42):
# # github.com/santi-gf wrote this file. As long as you retain this notice you
# # can do whatever you want with this stuff. If we meet some day, and you think
# # this stuff is worth it, you can buy me a beer in return.
# # ----------------------------------------------------------------------------
# #
#

set -e

echo "Creating partitions..."
parted -s /dev/sda mklabel msdos
parted -s -a optimal /dev/sda mkpart primary ext2 0% 100%
parted -s /dev/sda set 1 boot on

echo "Formatting partitions..."
mkfs.ext2 -F /dev/sda1

echo "adjust your timezone..."
ln -f -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

echo "Configuring Spanish language..."
loadkeys es echo es_ES.UTF-8 UTF-8 > /etc/locale.gen
echo LANG=es_ES.UTF-8 > /etc/locale.conf locale-gen

echo "GRUB no wait time..."
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g'/etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
