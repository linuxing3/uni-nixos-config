sudo mount /dev/mapper/crypted-nixos-for-install /install # create-btrfs
sudo btrfs subvolume create /install/@boot # create-btrfs
sudo btrfs subvolume create /install/@nix  # create-btrfs
sudo btrfs subvolume create /install/@guix  # create-btrfs
sudo btrfs subvolume create /install/@tmp  # create-btrfs
sudo btrfs subvolume create /install/@swap  # create-btrfs
sudo btrfs subvolume create /install/@persistent  # create-btrfs
sudo btrfs subvolume create /install/@snapshots  # create-btrfs
sudo umount /install # create-btrfs
