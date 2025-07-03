#!/usr/bin/env zsh
# Deploy and install this nixos system.

zparseopts -E -F -D -- -flake=flake \
                       -user=user \
                       -host=host \
                       -root=root\
                       -dest=dest || exit 1

root="${root[2]:-/mnt/}"
flake="${flake[2]:-${root}/etc/uni-nixos-config}"
host="${host[2]:-laptop}"
user="${user[2]:-linuxing3}"
theme="${theme[2]:-autumnal}"
dest="${dest[2]:-$root/home/$user/.config/uni-nixos-config}"

if [[ "$USER" == nixos ]]; then
  >&2 echo "Error: not in the nixos installer"
  exit 1
elif [[ -z "$host" ]]; then
  >&2 echo "Error: no --host set"
  exit 2
fi

export HEYENV="{\"user\":\"$user\",\"host\":\"$host\",\"path\":\"${flake}\",\"theme\":\"${theme}\"}"
if [[ -n "$disk" ]]; then
  nix run 'github:nix-community/disko/latest#disko-install' -- \
      --impure \
      --show-trace \
      --no-bootloader \
      --flake "${flake}#${host}" \
      --disk main "${disk}"
else
  nixos-install \
      --impure \
      --show-trace \
      --no-bootloader \
      --root "$root" \
      --flake "${flake}#${host}"
fi

