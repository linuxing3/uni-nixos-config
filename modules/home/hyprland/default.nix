{flake, ...}: {
  imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    flake.inputs.hyprland.homeManagerModules.default
  ];
}
