{pkgs, ...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = ''
    menuentry "[1] Nixos Warbler /dev/sdb4" --class nixos --unrestricted {
      search --set=drive1 --fs-uuid 66F6-957D
      linux ($drive1)/luks-extra-bzImage init=/nix/store/hk8q1cibcsgg5l08i4gh2mnp9frpc9xq-nixos-system-ai-25.05.20250508.dda3dcd/init loglevel=4
      initrd ($drive1)/luks-extra-initrd
    }
    menuentry '[2] NixOS Warbler /dev/sdb1' --class nixos --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-simple-361434b5-c39b-4bf0-9fc0-956e8a4e5f5b' {
    	insmod part_msdos
    	insmod fat
    	set root='hd1,msdos2'
    	if [ x$feature_platform_search_hint = xy ]; then
    	  search --no-floppy --fs-uuid --set=root --hint-ieee1275='ieee1275/(null)/sas/disk@0,msdos2' --hint-bios=hd1,msdos2 --hint-efi=hd1,msdos2 --hint-baremetal=ahci1,msdos2  66F6-957D
    	else
    	  search --no-floppy --fs-uuid --set=root 66F6-957D
    	fi
    	linux //kernels/dfldf6vkhlyq7jf5ydzqcyjlbkpl2amv-linux-zen-6.14.5-bzImage init=/nix/store/fw2hd75zq0yfq1cnch76mypsfzsn15xj-nixos-system-ai-25.05.20250508.dda3dcd/init loglevel=4
    	initrd //kernels/znc70mvnhmzilqx3jv5sh7bc7l03409w-initrd-linux-zen-6.14.5-initrd
    }
    menuentry "[3] NixOS Warbler /dev/sdb3" --class nixos --unrestricted {
      search --set=drive1 --fs-uuid 66F6-957D
      linux ($drive1)/luks-bzImage init=/nix/store/9n5m93a3750b1bp8l8axd63pvybzbmwk-nixos-system-ai-23.11.20231220.d65bcea/init loglevel=4
      initrd ($drive1)/boot/luks-initrd
    }
    menuentry "[4] NixOS Live Installer/Rescue" {
      search --set=drive1 --fs-uuid 66F6-957D
      linux ($drive1)/live-bzImage findiso=/nixos.iso init=/nix/store/6ljga1i26k7w7qnxpi1nzgg5cfmngxr5-nixos-system-nixos-25.05.804219.36ab78dab7da/init root=LABEL=nixos-minimal-25.05-x86_64 loglevel=4
      initrd ($drive1)/live-initrd
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
    postDeviceCommands = ''
      mkdir -p /run/rooooot
      mount -o subvol==@root /dev/disk/by-uuid/bc51540f-f085-44a3-ad6c-46bf2e138f6b /run/rooooot
      btrfs subvolume delete /run/rooooot
      btrfs subvolume snapshot / /run/rooooot
    '';
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
