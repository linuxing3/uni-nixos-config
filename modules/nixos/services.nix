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

  environment.systemPackages = with pkgs; [
    dosfstools
    exfat
    nfs-utils
    btrfs-progs
    btrfs-snap
    # for hp printer
    hplip
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
    dataDir = "/var/lib/postgresql/15";
    port = 5432;
    enableTCPIP = true;
    ensureDatabases = ["myapp_dev"];
    ensureUsers = [
      {
        name = "postgres";
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local all      all                    trust
      host  all      all     localhost      trust
      host  all      all     127.0.0.1/32   trust
      host  all      all     ::1/128        trust
      host  all      all     laptop         scram-sha-256
    '';
    initialScript = pkgs.writeText "postgresql-init.sql" ''
      CREATE USER postgres WITH PASSWORD 'mm909623';
      CREATE DATABASE myapp_dev WITH OWNER postgres;
      GRANT ALL PRIVILEGES ON DATABASE myapp_dev TO postgres;

      CREATE USER linuxing3 WITH PASSWORD 'mm909623';
      CREATE DATABASE mydb_dev WITH OWNER linuxing3;
      GRANT ALL PRIVILEGES ON DATABASE mydb_dev TO linuxing3;

      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud WITH OWNER nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };
}
