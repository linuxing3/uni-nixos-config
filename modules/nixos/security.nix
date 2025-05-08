{
  username,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  security.rtkit.enable = true;
  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = ["${username}"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Enable automatic login for the user.
  services.getty.autologinUser = "${username}";
  environment.systemPackages = with pkgs; [
    pass
    pass-wayland
    pass-git-helper

    gopass
    gopass-jsonapi

    sops
    age
  ];

  sops.defaultSopsFile = ./secrets/password.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

  #  general password
  sops.secrets.github = {
    owner = "${username}";
  };
  # github token
  sops.secrets.password = {
    owner = "${username}";
  };
  # qq email password
  sops.secrets."email/qq" = {
    owner = "${username}";
  };
  # mfa email password
  sops.secrets."email/mfa" = {
    owner = "${username}";
  };
}
