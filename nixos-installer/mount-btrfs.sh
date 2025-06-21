#!/usr/bin/env bash
#
# sudo mkdir /mnt/{nix,gnu,tmp,swap,persistent,snapshots,boot}  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@boot /dev/mapper/crypted-nixos /mnt/boot # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@nix /dev/mapper/crypted-nixos /mnt/nix  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@guix /dev/mapper/crypted-nixos /mnt/gnu  # mount-1
sudo mount -o compress-force=zstd:1,subvol=@tmp /dev/mapper/crypted-nixos /mnt/tmp  # mount-1

sudo mount -o compress-force=zstd:1,noatime,subvol=@persistent /dev/mapper/crypted-nixos /mnt/persistent  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@snapshots /dev/mapper/crypted-nixos /mnt/snapshots  # mount-1

sudo mount -o subvol=@swap /dev/mapper/crypted-nixos /mnt/swap  # mount-1
# sudo btrfs filesystem mkswapfile --size 96g --uuid clear /mnt/swap/swapfile  # mount-1
sudo swapon /mnt/swap/swapfile  # mount-1
