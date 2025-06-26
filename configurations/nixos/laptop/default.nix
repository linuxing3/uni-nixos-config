# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = with self.nixosModules; [
    default
    hardware
    system
    services
    pipewire
    security
    wayland
    xserver
    program
    fhs
    guix
    nh
    fonts
    emacs
    ./bootloader.nix
    ./network.nix
    ./configuration.nix
    ./impermanence.nix
  ];
}
