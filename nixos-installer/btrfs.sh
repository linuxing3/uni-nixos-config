sudo mount /dev/mapper/luks-2ae9170b-74e6-497f-819a-402d2697a01f /mnt  # create-btrfs
sudo btrfs subvolume create /mnt/@boot # create-btrfs
sudo btrfs subvolume create /mnt/@nix  # create-btrfs
sudo btrfs subvolume create /mnt/@guix  # create-btrfs
sudo btrfs subvolume create /mnt/@tmp  # create-btrfs
sudo btrfs subvolume create /mnt/@swap  # create-btrfs
sudo btrfs subvolume create /mnt/@persistent  # create-btrfs
sudo btrfs subvolume create /mnt/@snapshots  # create-btrfs
sudo umount /mnt  # create-btrfs
