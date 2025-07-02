#!/usr/bin/env bash

sudo mkdir /install  # mount-1
sudo mkdir /install/{nix,gnu,tmp,swap,persistent,snapshots}  # mount-1

sudo mount -o compress-force=zstd:1,noatime,subvol=@nix /dev/mapper/crypted-nixos-for-install /install/nix  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@guix /dev/mapper/crypted-nixos-for-install /install/gnu  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@persistent /dev/mapper/crypted-nixos-for-install /install/persistent  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@snapshots /dev/mapper/crypted-nixos-for-install /install/snapshots  # mount-1

sudo mount -o compress-force=zstd:1,subvol=@tmp /dev/mapper/crypted-nixos-for-install /install/tmp  # mount-1

sudo mount -o subvol=@swap /dev/mapper/crypted-nixos-for-install /install/swap  # mount-1
sudo btrfs filesystem mkswapfile --size 96g --uuid clear /install/swap/swapfile  # mount-1
sudo swapon /install/swap/swapfile  # mount-1
