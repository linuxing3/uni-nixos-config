{
  config,
  pkgs,
  ...
}: {
  # Add user to libvirtd group
  users.users.linuxing3.extraGroups = ["libvirtd"];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    adwaita-icon-theme
  ];

  networking.nftables.enable = true;

  # Manage the virtualisation services
  virtualisation = {
    podman.enable = true;
    incus.enable = true;
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
