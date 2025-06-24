{pkgs, ...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.extraEntries = ''
    menuentry "[1] Luks NixOS extra" --class nixos --unrestricted {
      search --set=drive1 --fs-uuid 66F6-957D
      linux ($drive1)/luks-extra-bzImage init=/nix/store/hk8q1cibcsgg5l08i4gh2mnp9frpc9xq-nixos-system-ai-25.05.20250508.dda3dcd/init loglevel=4
      initrd ($drive1)/luks-extra-initrd
    }
    menuentry "[2] Luks NixOS" --class nixos --unrestricted {
      search --set=drive1 --fs-uuid 66F6-957D
      linux ($drive1)/luks-bzImage init=/nix/store/9n5m93a3750b1bp8l8axd63pvybzbmwk-nixos-system-ai-23.11.20231220.d65bcea/init loglevel=4
      initrd ($drive1)/boot/luks-initrd
    }
    menuentry "[3] NixOS Installer/Rescue" {
      search --set=drive1 --fs-uuid 66F6-957D
      linux ($drive1)/live-bzImage findiso=/nixos.iso init=/nix/store/6ljga1i26k7w7qnxpi1nzgg5cfmngxr5-nixos-system-nixos-25.05.804219.36ab78dab7da/init root=LABEL=nixos-minimal-25.05-x86_64 loglevel=4
      initrd ($drive1)/live-initrd
    }
  '';

  # clear /tmp on boot to get a stateless /tmp directory.
  boot.tmp.cleanOnBoot = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd = {
    luks.devices."crypted-nixos-extra" = {
      device = "/dev/disk/by-uuid/508dce0f-4054-46a8-949c-33c8cc949320";
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
