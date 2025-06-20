{
  pkgs,
  flake,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) mysecrets;
  inherit (inputs) agenix;
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
    agenix-cli

    cryptsetup
  ];

  # age secrets
  # secrets path: /run/agenix/...
  age.identityPaths = [
    "/home/linuxing3/.ssh/id_ed25519"
    "/home/linuxing3/.ssh/efwmc"
    "/home/linuxing3/.ssh/linuxing3"
    "/home/linuxing3/.ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets."generic" = {
    file = "${mysecrets}/nix-access-tokens.age";
  };

  # sops secrets
  sops.defaultSopsFile = "${mysecrets}/password.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/linuxing3/.config/sops/age/keys.txt";

  # secrets path: /run/secrets/...
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
