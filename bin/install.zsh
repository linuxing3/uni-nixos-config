#!/usr/bin/env zsh
# Deploy and install this nixos system.

function prepare() {
  # unmount /install
  # sudo cryptsetup luksOpen /dev/sdb4 crypted-nixos-install
  sudo mount -o compress-force=zstd:1,noatime,subvol=@nix /dev/mapper/crypted-nixos-install /install/nix  # mount-1
  sudo mount -o compress-force=zstd:1,noatime,subvol=@guix /dev/mapper/crypted-nixos-install /install/gnu  # mount-1
  sudo mount -o compress-force=zstd:1,noatime,subvol=@persistent /dev/mapper/crypted-nixos-install /install/persistent  # mount-1
  sudo mount -o compress-force=zstd:1,noatime,subvol=@snapshots /dev/mapper/crypted-nixos-install /install/snapshots  # mount-1

  sudo mount -o compress-force=zstd:1,subvol=@tmp /dev/mapper/crypted-nixos-install /install/tmp  # mount-1

  sudo mount -o subvol=@swap /dev/mapper/crypted-nixos-install /install/swap  # mount-1
  sudo rm /install/swap/swapfile
  sudo btrfs filesystem mkswapfile --size 24g --uuid clear /install/swap/swapfile  # mount-1
  sudo swapon /install/swap/swapfile  # mount-1
}

function main() {
  zparseopts -E -D -F -- -flake:=flake -user:=user -host:=host -dest:=dest -root:=root || exit 1

  local root="${${root[2]}:-/install}"
  local flake="${${flake[2]}:-/etc/dotfiles}"
  local host="${${host[2]}:-$(hostname)}"
  local user="${${user[2]}:-linuxing3}"
  local dest="${dest[2]:-$root/home/$user/.config/dotfiles}"

  if [[ "$USER" == nixos ]]; then
    >&2 echo "Error: not in the nixos installer"
    exit 1
  elif [[ -z "$host" ]]; then
    >&2 echo "Error: no --host set"
    exit 2
  fi
  
  if [[ ! -d "$root/$flake" ]]; then
    # local url=https://github.com/hlissner/dotfiles
    # [[ "$user" == hlissner ]] && url="git@github.com:hlissner/dotfiles.git"
    sudo rm -rf "$flake"
    sudo cp -r /home/linuxing3/sources/hlissner-nixos-config $root/$flake
    # git clone --recursive "$url" "$flake"
  fi
  
  export HEYENV="{\"user\":\"$user\",\"host\":\"$host\",\"path\":\"$flake\",\"theme\":\"$THEME\"}"
  sudo nixos-install \
      --impure \
      --show-trace \
      --no-bootloader \
      --root "$root" \
      --flake "${root}${flake}#${host}"
}

set -e
prepare
# main $*
