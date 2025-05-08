# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.nixosModules.default
    self.nixosModules.system
    self.nixosModules.wayland
    self.nixosModules.xserver
    self.nixosModules.pipewire
    self.nixosModules.security
    self.nixosModules.services
    self.nixosModules.program
    ./configuration.nix
  ];
}
