{
  pkgs,
  flake,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) self;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  security.rtkit.enable = true;
  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = ["linuxing3"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Enable automatic login for the user.
  services.getty.autologinUser = "linuxing3";
  environment.systemPackages = with pkgs; [
    pass
    pass-wayland
    pass-git-helper

    gopass
    gopass-jsonapi

    sops
    age

    cryptsetup
  ];

  sops.defaultSopsFile = ./secrets/password.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/linuxing3/.config/sops/age/keys.txt";

  sops.secrets.username = {
    owner = "linuxing3";
  };
  #  general password
  sops.secrets.github = {
    owner = "linuxing3";
  };
  # github token
  sops.secrets.password = {
    owner = "linuxing3";
  };
  # qq email password
  sops.secrets."email/qq" = {
    owner = "linuxing3";
  };
  # mfa email password
  sops.secrets."email/mfa" = {
    owner = "linuxing3";
  };
}
