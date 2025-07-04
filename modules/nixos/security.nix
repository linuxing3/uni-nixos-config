{
  pkgs,
  config,
  flake,
  lib,
  ...
}: let
  inherit (flake) inputs;
  inherit (inputs) mysecrets;
  user_access = {
    owner = "linuxing3";
    mode = "0500";
  };

  # Create attribute set from list of .age files
  mapListToAttrs = list:
    lib.listToAttrs (map (name: {
      name = builtins.replaceStrings [".age"] [""] name;
      value = {
        file = "${inputs.mysecrets}/${name}";
        mode = user_access.mode;
        owner = user_access.owner;
      };
    }) (lib.filter (name: lib.hasSuffix ".age" name) list));

  # Get all .age files in secrets directory
  ageFiles = lib.attrNames (lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".age" name)
    (builtins.readDir "${inputs.mysecrets}"));
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

  age.secrets = mapListToAttrs ageFiles;

  environment.sessionVariables = {
    "DEEPSEEK_API_KEY" = ''
      $(${pkgs.coreutils}/bin/cat ${config.age.secrets."deepseek-token".path})
    '';
    "GEMINI_API_KEY" = ''
      $(${pkgs.coreutils}/bin/cat ${config.age.secrets."gemini-token".path})
    '';
  };

  # sops secrets
  sops.defaultSopsFile = "${mysecrets}/password.yaml";
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/linuxing3/.config/sops/age/keys.txt";

  # secrets path: /run/secrets/...
  sops.secrets.username = user_access;
  #  general password
  sops.secrets.github = user_access;
  # github token
  sops.secrets.password = user_access;
  # qq email password
  sops.secrets."email/qq" = user_access;
  # mfa email password
  sops.secrets."email/mfa" = user_access;
}
