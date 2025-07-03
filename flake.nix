{
  description = "A home-manager template providing useful tools & settings for Nix-based development";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";

    #flake parts
    agenix-shell.url = "github:aciceri/agenix-shell";
    devenv.url = "github:cachix/devenv";
    files.url = "github:mightyiam/files";

    # system inputs
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "flake-parts";

    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland";
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    agenix = {
      url = "github:ryantm/agenix/4835b1dc898959d8547a871ef484930675cb47f1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mysecrets = {
      url = "git+ssh://git@github.com/linuxing3/mysecrets.git?shallow=1";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    args = {
      inherit self;
      inherit (nixpkgs) lib;
      pkgs = import nixpkgs {};
    };
    lib = import ./modules/hey/lib args;
  in
    # hey flake
    lib.mkFlake inputs {
      systems = ["x86_64-linux"];
      inherit lib;
      hosts = lib.mapHosts ./modules/hey/hosts;
      modules.default = import ./modules/hey;
      apps.build = lib.mkApp ./bin/build.zsh;
      apps.install = lib.mkApp /hey/bin/install.zsh;
      checks = lib.mapModules ./modules/hey/test import;
    }
    # unified flake
    // inputs.nixos-unified.lib.mkFlake
    {
      inherit inputs;
      root = ./.;
    };
}
