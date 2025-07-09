#!/usr/bin/env zsh
# Deploy and install this nixos system.

function delete-btrfs() {
  # sudo cryptsetup close crypted-nixos-install
  sudo cryptsetup luksOpen /dev/sdb4 crypted-nixos-install

  sudo mount /dev/mapper/crypted-nixos-install /install # delete-btrfs

  sudo btrfs subvolume delete /install/@nix  # delete-btrfs
  sudo btrfs subvolume delete /install/@guix  # delete-btrfs
  sudo btrfs subvolume delete /install/@persistent  # delete-btrfs
  sudo btrfs subvolume delete /install/@snapshots  # delete-btrfs
  sudo btrfs subvolume delete /install/@tmp  # delete-btrfs
  sudo btrfs subvolume delete /install/@swap  # delete-btrfs
  sudo umount /install # create-btrfs
}

function create-btrfs() {
  sudo cryptsetup luksOpen /dev/sdb4 crypted-nixos-install
  sudo mount /dev/mapper/crypted-nixos-install /install # create-btrfs
  sudo btrfs subvolume create /install/@nix  # create-btrfs
  sudo btrfs subvolume create /install/@guix  # create-btrfs
  sudo btrfs subvolume create /install/@persistent  # create-btrfs
  sudo btrfs subvolume create /install/@snapshots  # create-btrfs
  sudo btrfs subvolume create /install/@tmp  # create-btrfs
  sudo btrfs subvolume create /install/@swap  # create-btrfs
  sudo umount /install # create-btrfs
}
  
function prepare-btrfs () {
  sudo cryptsetup luksOpen /dev/sdb4 crypted-nixos-install
  sudo mount /dev/mapper/crypted-nixos-install /install # mount-1
  sudo mount -o compress-force=zstd:1,noatime,subvol=@nix /dev/mapper/crypted-nixos-install /install/nix  # mount-1
  sudo mount -o compress-force=zstd:1,noatime,subvol=@guix /dev/mapper/crypted-nixos-install /install/gnu  # mount-1
  sudo mount -o compress-force=zstd:1,noatime,subvol=@persistent /dev/mapper/crypted-nixos-install /install/persistent  # mount-1
  sudo mount -o compress-force=zstd:1,noatime,subvol=@snapshots /dev/mapper/crypted-nixos-install /install/snapshots  # mount-1
  sudo mount -o compress-force=zstd:1,subvol=@tmp /dev/mapper/crypted-nixos-install /install/tmp  # mount-1
  sudo mount -o subvol=@swap /dev/mapper/crypted-nixos-install /install/swap  # mount-1
  # sudo rm /install/swap/swapfile
  # sudo btrfs filesystem mkswapfile --size 24g --uuid clear /install/swap/swapfile  # mount-1
  # sudo swapon /install/swap/swapfile  # mount-1
}

function install-nixos() {
    sudo nixos-install \
     --root /install \
     --flake .#laptop \
     --no-bootloader\
     --show-trace \
     --option substituters https://mirrors.ustc.edu.cn/nix-channels/store \
     -j 4
}

set -e
# delete-btrfs
# create-btrfs
prepare-btrfs
install-nixos
