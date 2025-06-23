# List of users for darwin or nixos system and their top-level configuration.
{
  flake,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (flake.inputs) self;
  mapListToAttrs = m: f:
    lib.listToAttrs (map (name: {
        inherit name;
        value = f name;
      })
      m);
  initialHashedPassword = "$7$CU..../....qejXlflvte/eOFsclGcRG0$vPxrUfc8MZh/9VY1py86B8GVs516vrQcScjvN/YEs5B";
  mainSshAuthorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOm5HPR9bV+g/kWwDLzBCgCIija6GnHseUEthM+vX40l linuxing3@qq.com"];
in {
  options = {
    myusers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of usernames";
      defaultText = "All users under ./configuration/users are included by default";
      default = let
        dirContents = builtins.readDir (self + /configurations/home);
        fileNames = builtins.attrNames dirContents; # Extracts keys: [ "linuxing3.nix" ]
        regularFiles = builtins.filter (name: dirContents.${name} == "regular") fileNames; # Filters for regular files
        baseNames = map (name: builtins.replaceStrings [".nix"] [""] name) regularFiles; # Removes .nix extension
      in
        baseNames;
    };
  };

  config = {
    # For home-manager to work.
    users.users =
      mapListToAttrs config.myusers (
        name:
          lib.optionalAttrs pkgs.stdenv.isDarwin
          {
            home = "/Users/${name}";
          }
          // lib.optionalAttrs pkgs.stdenv.isLinux {
            isNormalUser = true;
            shell = pkgs.zsh;
            initialHashedPassword = initialHashedPassword;
            openssh.authorizedKeys.keys = mainSshAuthorizedKeys;
            extraGroups = [
              name
              "users"
              "networkmanager"
              "wheel"
              "docker"
              "wireshark"
              "adbusers"
              "libvirtd"
            ];
          }
      )
      // {
        root = {
          # root's ssh key are mainly used for remote deployment
          initialHashedPassword = initialHashedPassword;
          openssh.authorizedKeys.keys = mainSshAuthorizedKeys;
        };
      };

    # Enable home-manager for our user
    home-manager.users = mapListToAttrs config.myusers (name: {
      imports = [(self + /configurations/home/${name}.nix)];
    });

    # All users can add Nix caches.
    nix.settings.trusted-users =
      [
        "root"
      ]
      ++ config.myusers;
  };
}
