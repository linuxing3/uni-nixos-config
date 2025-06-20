{
  pkgs,
  flake,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) mysecrets;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.agenix.nixosModules.default
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
    agenix
  ];

  # age secrets
  age.IdentityPaths = [
    "${mysecrets}/public/romantic.pub"
    "${mysecrets}/public/efwmc.pub"
  ];

  age.secrets."generic" = {
    file = "${mysecrets}/nix-generic-pass.age";
  };

  # sops secrets
  sops.defaultSopsFile = "${mysecrets}/password.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${mysecrets}/age/keys.txt";

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
