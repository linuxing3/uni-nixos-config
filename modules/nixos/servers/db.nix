{ pkgs, ... }: {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "nixcloud" "efwmc" ];
    # enableTCPIP = true;
    settings = {
      port = 5432;
    };
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser origin-address auth-method
      local efwmc all     peer        map=superuser_map
      # This will setup Postgresql with a default DB superuser/admin "postgres"
      # a database "mydatabase" and let every DB user have access to it without a password
      # through a "local" Unix socket "/var/lib/postgresql"
      # (TCP/IP is disabled by default because it's less performant and less secure).
      # local all       all     trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'mm909623' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
      CREATE ROLE efwmc WITH LOGIN PASSWORD 'mm909623' CREATEDB;
      CREATE DATABASE efwmc;
      GRANT ALL PRIVILEGES ON DATABASE efwmc TO efwmc;
    '';
    identMap = ''
      # ArbitraryMapName systemUser DBUser
      superuser_map      root      postgres
      superuser_map      postgres  postgres
      superuser_map      efwmc     postgres
      # Let other names login as themselves
      superuser_map      /^(.*)$   \1
    '';
  };
}
