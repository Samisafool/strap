#!/usr/bin/env zsh

# strap: A simple set of scripts to set up arch
# Copyright (C) 2022 Sam

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

. $(dirname "$0")/common.zsh

echo "Choose locale now."
read -rsk 1
ln -sf /usr/share/zoneinfo/"$(cd /usr/share/zoneinfo; fzf)" /etc/localtime
hwclock --systohc

locale-gen

bootctl install
touch /etc/vconsole.conf
mkinitcpio -P -c $dir/mkinitcpio
cp ./cmd /etc/kernel/cmdline
sbctl bundle -k /boot/vmlinuz-linux-lts -f /boot/initramfs-linux-lts.img -c /etc/kernel/cmdline /boot/efi/EFI/Linux/arch.efi

useradd -mG wheel arch
passwd arch
passwd

echo "Do more setup now..."

exec zsh
