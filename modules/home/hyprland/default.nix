{flake, ...}: {
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    ./anyrun.nix
    flake.inputs.hyprland.homeManagerModules.default
  ];
}
