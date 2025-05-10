{flake, ...}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    self.homeModules.default
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = {
    username = "linuxing3";
    fullname = "Xing Wenju";
    email = "linuxing3@qq.com";
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
