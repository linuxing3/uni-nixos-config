# NOTE: `cat shoukei.md | grep luks > luks.sh` to generate this script
# encrypt the root partition with luks2 and argon2id, will prompt for a passphrase, which will be used to unlock the partition.
cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --hash sha512 --iter-time 5000 --key-size 256 --pbkdf argon2id --use-random --verify-passphrase /dev/sdb3
cryptsetup luksDump /dev/sdb3
cryptsetup luksOpen /dev/sdb3 crypted-nixos
sudo cryptsetup luksChangeKey /path/to/dev/
