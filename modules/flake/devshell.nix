# Top-level flake glue to get our configuration working
{
  inputs,
  lib,
  ...
}: let
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
      };
    }) (lib.filter (name: lib.hasSuffix ".age" name) list));

  # Get all .age files in secrets directory
  ageFiles = lib.attrNames (lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".age" name)
    (builtins.readDir "${inputs.mysecrets}"));
in {
  imports = [
    inputs.agenix-shell.flakeModules.default
    inputs.devenv.flakeModule
  ];

  agenix-shell.identityPaths = [
    "/home/linuxing3/.ssh/id_ed25519"
    "/home/linuxing3/.ssh/efwmc"
    "/home/linuxing3/.ssh/linuxing3"
    "/home/linuxing3/.ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  agenix-shell.secrets = mapListToAttrs ageFiles;

  # settings devShell

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devenv.shells = {
      develop = {
        languages.c.enable = true;
        languages.cplusplus.enable = true;
        languages.zig.enable = true;
      };
    };

    devShells.default =
      import ./shell.nix
      // {
        shellHook = ''
          source ${lib.getExe config.agenix-shell.installationScript}
        '';
      };
  };
}
