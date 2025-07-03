# Top-level flake glue to get our configuration working
{
  inputs,
  nixpkgs,
  ...
}: let
  inherit (inputs) self;
  args = {
    inherit self;
    inherit (nixpkgs) lib;
    pkgs = import nixpkgs {};
  };
  lib = import ../hey/lib args;
in
  with builtins;
  with lib;
    mkFlake inputs {
      systems = ["x86_64-linux"];
      inherit lib;
      hosts = mapHosts ../hey/hosts;
      modules.default = import ../hey;
      apps.install = mkApp ../hey/bin/install.zsh;
    }
    // {
      imports = [
        inputs.nixos-unified.flakeModules.default
        inputs.nixos-unified.flakeModules.autoWire
      ];
      perSystem = {
        self',
        pkgs,
        ...
      }: {
        # For 'nix fmt'
        formatter = pkgs.nixpkgs-fmt;

        # Enables 'nix run' to activate.
        packages.default = self'.packages.activate;

        # hey modules
      };
    }
