# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.linuxing3 = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
  };

  environment.systemPackages = with pkgs; [
     wget curl
     helix   neovim vim emacs
     tmux
     yazi	lf     ranger
     git     lazygit
     dosfstools
     exfat
     nfs-utils
     btrfs-progs
     btrfs-snap
  ];

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryFlavor = "";
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [];

  services.autofs = {
    enable = true;
    autoMaster = let
      mapConf = pkgs.writeText "autofs.mnt" ''
        windows -fstype=ntfs :/dev/disk/by-uuid/CAA069BBA069AF1F
        app -fstype=ntfs :/dev/disk/by-uuid/283698C136989204
        data -fstype=ntfs :/dev/disk/by-uuid/2286A96C86A94161
      '';
    in ''
      /autofs ${mapConf} --timeout 20
    '';
  };

  services.openssh.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?

}

