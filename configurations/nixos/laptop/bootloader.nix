{
  pkgs,
  flake,
  ...
}: {
  inherit (flake) inputs;
  imports = [
    inputs.grub2-themes.nixosModules.default
  ];
  boot.loader.grub2-theme = {
    enable = true;
    theme = "stylish";
    footer = true;
    customResolution = "1600x900"; # Optional: Set a custom resolution
  };
  boot.loader.grub = {
    enable = true;
    device = "/dev/sdb";
    useOSProber = true;
    extraEntries = ''
      menuentry "[$] NixOS Custom" {
        search --set=drive1 --fs-uuid 66F6-957D
        configfile ($drive1)/grub/custom.cfg
      }
      menuentry "[!] NixOS Live Installer/Rescue" {
        search --set=drive1 --fs-uuid 66F6-957D
        linux ($drive1)/live-bzImage findiso=/nixos.iso init=/nix/store/6ljga1i26k7w7qnxpi1nzgg5cfmngxr5-nixos-system-nixos-25.05.804219.36ab78dab7da/init root=LABEL=nixos-minimal-25.05-x86_64 loglevel=4
        initrd ($drive1)/live-initrd
      }
    '';
  };

  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

  # For a truly silent boot!
  boot.consoleLogLevel = 0;
  boot.kernelParams = [
    "quiet"
    "splash"
    "udev.log_level=3"
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd = {
    verbose = false;
    luks.devices."crypted-nixos" = {
      device = "/dev/disk/by-uuid/2ae9170b-74e6-497f-819a-402d2697a01f";
      allowDiscards = true;
      bypassWorkqueues = true;
    };
    # postDeviceCommands = ''
    #   mkdir -p /run/rooooot
    #   mount -o subvol==@root /dev/mapper/crypted-nixos /run/rooooot
    #   btrfs subvolume delete /run/rooooot
    #   btrfs subvolume snapshot / /run/rooooot
    # '';
  };

  boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
  ];
}
