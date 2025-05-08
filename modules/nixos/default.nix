# This is your nixos configuration.
# For home configuration, see /modules/home/*
{flake, ...}: {
  imports = with flake.inputs.self.nixosModules; [
    common
  ];
  services.openssh.enable = true;
}
