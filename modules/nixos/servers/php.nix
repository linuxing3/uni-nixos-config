{ pkgs
, config
, ...
}: {
  users.users.phpdemo = {
    isSystemUser = true;
    createHome = true;
    home = "/var/www/root";
    group = "wheel";
  };
  users.groups.phpdemo = { };

  services.phpfpm.pools.phpdemo = {
    user = "phpdemo";
    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
    };
  };

  services.phpfpm.pools.nobody = {
    user = "nobody";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."miluna.efwmc.org" = {
      forceSSL = true;
      sslCertificate = "/etc/openssl/efwmc.org.crt";
      sslCertificateKey = "/etc/openssl/efwmc.org.key";
      serverName = "miluna.efwmc.org";
      locations."/" = {
        root = "/var/www/root";
        extraConfig = ''
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_index index.php;
          fastcgi_pass unix:${config.services.phpfpm.pools.phpdemo.socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
      };
    };
    virtualHosts."blog.efwmc.org" = {
      forceSSL = true;
      serverName = "blog.efwmc.org";
      sslCertificate = "/etc/openssl/efwmc.org.crt";
      sslCertificateKey = "/etc/openssl/efwmc.org.key";
      locations."/" = {
        root = "/var/www/blog";
        extraConfig = ''
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_index index.php;
          fastcgi_pass unix:${config.services.phpfpm.pools.nobody.socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
      };
    };
  };
}
