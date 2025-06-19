## Quick start

------

|               | Wayland                 | X11                                              |
|---------------|-------------------------|--------------------------------------------------|
| **Shell:**    | zsh + foot              | "                                                |
| **WM:**       | hyprland + waybar       | lightdm + lightdm-mini-greeter + bspwm + polybar |
| **Editor:**   | [Doom Emacs][doomemacs] | "                                                |
| **Terminal:** | foot                    | st                                               |
| **Launcher:** | rofi                    | "                                                |
| **Browser:**  | zen-browser             | "                                                |

-----

1. Acquire or build a NixOS image:
   ```sh
   $ wget -O nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
   ```

2. Write it to a USB drive:
   ```sh
   # Replace /dev/sdX with the correct partition!
   $ cp nixos.iso /dev/sdX
   ```
   
3. Restart and boot into the installer.

4. Do your partitions and mount your root to `/mnt` 

5. Clone these dotfiles somewhere:
   ```sh
   $ git clone --recursive https://github.com/linuxing3/uni-nixos-config
   ```
   
6. Create a host config in `configurations/nixos/`

```nix
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = with self.nixosModules; [
    default
    bootloader
    hardware
    network
    system
    services
    pipewire
    security
    wayland
    xserver
    program
    nh
    emacs
    ./configuration.nix
  ];
}
```

7. Rebuild:
   ```sh
   nix run
