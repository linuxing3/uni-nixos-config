sudo mount /dev/mapper/crypted-nixos /mnt  # create-btrfs
sudo btrfs subvolume create /mnt/@boot # create-btrfs
sudo btrfs subvolume create /mnt/@nix  # create-btrfs
sudo btrfs subvolume create /mnt/@guix  # create-btrfs
sudo btrfs subvolume create /mnt/@tmp  # create-btrfs
sudo btrfs subvolume create /mnt/@swap  # create-btrfs
sudo btrfs subvolume create /mnt/@persistent  # create-btrfs
sudo btrfs subvolume create /mnt/@snapshots  # create-btrfs
sudo umount /mnt  # create-btrfs
