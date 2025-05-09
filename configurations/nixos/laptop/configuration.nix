# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "laptop"; # Define your hostname.

  networking = {
    networkmanager.enable = true;
    interfaces.eno1.ipv4.addresses = [
      {
        address = "10.10.30.21";
        prefixLength = 24;
      }
    ];
    defaultGateway = "10.10.30.1";
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
      ];
      allowedUDPPorts = [
        59010
        59011
      ];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11"; # Did you read the comment?
}
