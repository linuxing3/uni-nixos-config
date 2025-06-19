sudo mkdir /mnt/{nix,gnu,tmp,swap,persistent,snapshots,boot}  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@boot /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt/boot # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@nix /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt/nix  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@guix /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt/gnu  # mount-1
sudo mount -o compress-force=zstd:1,subvol=@tmp /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt/tmp  # mount-1
sudo mount -o subvol=@swap /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt/swap  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@persistent /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt/persistent  # mount-1
sudo mount -o compress-force=zstd:1,noatime,subvol=@snapshots /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt/snapshots  # mount-1
sudo btrfs filesystem mkswapfile --size 96g --uuid clear /mnt/swap/swapfile  # mount-1
sudo swapon /mnt/swap/swapfile  # mount-1
