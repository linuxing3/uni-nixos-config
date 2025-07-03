#!/usr/bin/env zsh
# Deploy and install this nixos system.

zparseopts -E -F -D -- -flake=flake \
                       -user=user \
                       -host=host \
                       -dest=dest || exit 1

flake="${flake[2]:-/home/linuxing3/sources/uni-nixos-config}"
host="${host[2]:-laptop}"
user="${user[2]:-linuxing3}"
theme="${theme[2]:-autumnal}"

if [[ "$USER" == nixos ]]; then
  >&2 echo "Error: not in the nixos installer"
  exit 1
elif [[ -z "$host" ]]; then
  >&2 echo "Error: no --host set"
  exit 2
fi

export HEYENV="{\"user\":\"$user\",\"host\":\"$host\",\"path\":\"${flake}\",\"theme\":\"${theme}\"}"
nixos-rebuild build \
    --impure \
    --show-trace \
    --flake "${flake}#${host}"
