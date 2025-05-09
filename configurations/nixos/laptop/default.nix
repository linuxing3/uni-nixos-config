# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
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
    ./configuration.nix
  ];
}
