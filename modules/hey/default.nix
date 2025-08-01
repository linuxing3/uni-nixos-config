# default.nix
{
  hey,
  lib,
  options,
  config,
  ...
}:
with lib;
with hey.lib; {
  imports = mapModulesRec' ./modules import;

  options = with types; {
    modules = {};

    # Creates a simpler, polymorphic alias for users.users.$USER.
    user = mkOpt attrs {name = "";};
  };

  config = {
    assertions = [
      {
        assertion = config.user ? name;
        message = "config.user.name is not set!";
      }
    ];

    environment.sessionVariables = mkOrder 10 {
      DOTFILES_HOME = hey.dir;
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    user = {
      description = mkDefault "The primary user account";
      extraGroups = ["wheel"];
      isNormalUser = true;
      home = "/home/${config.user.name}";
      group = "users";
      uid = 1000;
    };
    users.users.${config.user.name} = mkAliasDefinitions options.user;

    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      initrd.grub = {
        enable = false;
        device = "/dev/sdb";
      };
      initrd.luks.devices = {
        "crypted-nixos" = {
          device = "/dev/disk/by-uuid/2ae9170b-74e6-497f-819a-402d2697a01f";
          allowDiscards = true;
          bypassWorkqueues = true;
        };
      };
    };

    # last partition as boot, device = "/dev/sdb2";
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/66F6-957D";
      fsType = "vfat";
    };

    # rootb: first partition ext4 as root
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/361434b5-c39b-4bf0-9fc0-956e8a4e5f5b";
      fsType = "ext4";
    };
    # swap file instead of a particular swapswapDevices
    fileSystems."/swap" = {
      device = "/dev/disk/by-uuid/bc51540f-f085-44a3-ad6c-46bf2e138f6b";
      fsType = "btrfs";
      options = ["subvol=@swap" "rw"];
    };
    # remount swapfile in read-write mode
    fileSystems."/swap/swapfile" = {
      # the swapfile is located in /swap subvolume, so we need to mount /swap first.
      depends = ["/swap"];
      device = "/swap/swapfile";
      fsType = "none";
      options = ["bind" "rw"];
    };
    swapDevices = [
      {device = "/swap/swapfile";}
      # {device = "/dev/disk/by-uuid/f033c305-e649-4599-aa05-ccf352da4121";}
    ];

    # persistent
    fileSystems."/persistent" = {
      device = "/dev/disk/by-uuid/bc51540f-f085-44a3-ad6c-46bf2e138f6b";
      fsType = "btrfs";
      options = ["subvol=@persistent" "noatime" "compress-force=zstd:1"];
      neededForBoot = true;
    };

    nix = let
      filteredInputs = filterAttrs (_: v: v ? outputs) hey.inputs;
      nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    in {
      extraOptions = ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes
      '';
      nixPath =
        nixPathInputs
        ++ [
          "nixpkgs-overlays=${hey.dir}/overlays"
          "dotfiles=${hey.dir}"
        ];
      registry = mapAttrs (_: v: {flake = v;}) filteredInputs;
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
        trusted-users = ["root" config.user.name];
        allowed-users = ["root" config.user.name];
        auto-optimise-store = true;
      };
    };

    system = {
      configurationRevision = with hey.inputs; mkIf (hey ? rev) hey.rev;
      stateVersion = "24.11";
    };

    # For unfree hardware my laptops/refurbed systems will likely have.
    hardware.enableRedistributableFirmware = true;

    # For `hey sync build-vm` (or `nixos-rebuild build-vm`)
    virtualisation.vmVariant.virtualisation = {
      memorySize = 1024; # default: 1024
      cores = 1; # default: 1
    };
  };
}
