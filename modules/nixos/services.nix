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
        win7 -fstype=ntfs :/dev/disk/by-uuid/523481103480F7ED
        app -fstype=ntfs :/dev/disk/by-uuid/9ED80960D8093853
        data -fstype=ntfs :/dev/disk/by-uuid/8A7CFD4C7CFD3393
        win10 -fstype=ntfs :/dev/disk/by-uuid/D250B5C050B5AC1B
      '';
    in ''
      /autofs ${mapConf} --timeout 20
    '';
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    dataDir = "/var/lib/postgresql/15"; # Custom data directory
    authentication = pkgs.lib.mkOverride 10 ''
      # Custom pg_hba.conf content
      local all all trust
      host all all 127.0.0.1/32 trust
    '';
    initialScript = pkgs.writeText "postgresql-init.sql" ''
      CREATE USER postgres WITH PASSWORD 'mm909623';
      CREATE USER linuxing3 WITH PASSWORD 'mm909623';
      CREATE DATABASE myapp_dev WITH OWNER postgres;
      CREATE DATABASE mydb_dev WITH OWNER linuxing3;
    '';
  };
}
