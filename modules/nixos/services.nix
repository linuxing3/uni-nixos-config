{pkgs, ...}: {
  services = {
    printing.enable = true;
    openssh.enable = true;
    gvfs.enable = true;
    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };
    dbus.enable = true;
    fstrim.enable = true;

    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];
  };
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  environment.systemPackages = [
    pkgs.dosfstools
    pkgs.exfat
    pkgs.nfs-utils
    pkgs.btrfs-progs
    pkgs.btrfs-snap
  ];
  services.autofs = {
    enable = true;
    autoMaster = let
      mapConf = pkgs.writeText "autofs.mnt" ''
        windows -fstype=ntfs :/dev/disk/by-uuid/CAA069BBA069AF1F
        app -fstype=ntfs :/dev/disk/by-uuid/283698C136989204
        data -fstype=ntfs :/dev/disk/by-uuid/2286A96C86A94161
      '';
    in ''
      /autofs ${mapConf} --timeout 20
    '';
  };
}
