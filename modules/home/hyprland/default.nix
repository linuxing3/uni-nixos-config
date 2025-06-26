{flake, ...}: let
  inherit (flake) inputs;
in {
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    ./anyrun.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
