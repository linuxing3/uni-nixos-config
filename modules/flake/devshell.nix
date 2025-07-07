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
  # setting agenix
  # imports = [
  #   inputs.agenix-shell.flakeModules.default
  # ];

  # agenix-shell.identityPaths = [
  #   "/home/linuxing3/.ssh/id_ed25519"
  #   "/home/linuxing3/.ssh/efwmc"
  #   "/home/linuxing3/.ssh/linuxing3"
  #   "/home/linuxing3/.ssh/ssh_host_ed25519_key"
  #   "/etc/ssh/ssh_host_ed25519_key"
  # ];

  # agenix-shell.secrets = mapListToAttrs ageFiles;

  # settings devShell

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default =
      pkgs.mkShell
      rec {
        buildInputs = with pkgs; [
          janet
        ];
        name = "hey-shell";
        meta.description = "Shell environment for modifying this Nix configuration";

        HEYENV = "{\"user\":\"linuxing3\",\"host\":\"laptop\",\"path\":\".\",\"theme\":\"autumnal\"}";

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
        INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;
        C_INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;
        CXX_INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;

        JANET_HEADERS_PATH = "${pkgs.janet}/include";
        JANET_LIB_PATH = "${pkgs.janet}/lib";
        JANET_TREE = "/home/linuxing3/.local/share/janet/jpm_tree";
        JANET_PATH = "/home/linuxing3/.local/share/janet/jpm_tree/lib";
        JANET_BUILDPATH = "/home/linuxing3/.local/share/janet/jpm_tree/build";
        XDG_BIN_HOME = "/home/linuxing3/.local/bin";
        XDG_CONFIG_HOME = "/home/linuxing3/.config";
        XDG_DATA_HOME = "/home/linuxing3/.local/share";
        XDG_CACHE_HOME = "/home/linuxing3/.local/cache";
        XDG_STATE_HOME = "/home/linuxing3/.local/state";
        DOTFILES_HOME = "/home/linuxing3/sources/uni-nixos-config";
        packages = with pkgs; [
          just
          nixd
          janet
          jpm
        ];

        # shellHook = ''
        #   source ${lib.getExe config.agenix-shell.installationScript}
        # '';
      };
  };
}
