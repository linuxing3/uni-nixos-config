{pkgs, ...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = ''
    menuentry "NixOS Installer/Rescue" {
      linux /boot/live-bzImage findiso=/nixos.iso init=/nix/store/6ljga1i26k7w7qnxpi1nzgg5cfmngxr5-nixos-system-nixos-25.05.804219.36ab78dab7da/init root=LABEL=nixos-minimal-25.05-x86_64 loglevel=4
      initrd /boot/live-initrd
    }
    menuentry "Luks NixOS" --class nixos --unrestricted {
      linux /boot/luks-bzImage init=/nix/store/9n5m93a3750b1bp8l8axd63pvybzbmwk-nixos-system-ai-23.11.20231220.d65bcea/init loglevel=4
      initrd /boot/luks-initrd
    }
  '';

  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd = {
    luks.devices."crypted-nixos" = {
      device = "/dev/disk/by-uuid/2ae9170b-74e6-497f-819a-402d2697a01f";
      allowDiscards = true;
      bypassWorkqueues = true;
    };
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
