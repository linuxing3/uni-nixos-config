{pkgs, ...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = ''
    menuentry "NixOS Installer/Rescue" {
      linux /boot/live-bzImage init=/nix/store/6ljga1i26k7w7qnxpi1nzgg5cfmngxr5-nixos-system-nixos-25.05.804219.36ab78dab7da/init root=LABEL=nixos-minimal-25.05-x86_64 loglevel=4 lsm=landlock,yama,bpf
      initrd /boot/live-initrd
    }
  '';

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.supportedFilesystems = ["ntfs"];
}
