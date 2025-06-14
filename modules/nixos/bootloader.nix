{pkgs, ...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdc";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = ''
    menuentry "NixOS on sda6" --class nixos --unrestricted {
    search --set=drive1 --fs-uuid 11eb8519-fd4f-412c-81f9-6d91224cadc3
    search --set=drive2 --fs-uuid 11eb8519-fd4f-412c-81f9-6d91224cadc3
      linux ($drive2)/@/nix/store/xcjnw6mp9my5ggjaj9m65cx06xh9x1dy-linux-zen-6.13.7/bzImage init=/nix/store/yqqk5m7j9icydhdk496fjv6hrv2fkqzk-nixos-system-desktop-25.05.20250315.c80f6a7/init loglevel=4
      initrd ($drive2)/@/nix/store/ilvfw3qkywvsddsbnnsbwlm45y527x6x-initrd-linux-zen-6.13.7/initrd
    }
  '';

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs"];
}
