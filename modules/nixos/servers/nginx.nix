# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ flake
, pkgs
, ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  environment.etc = {
    openssl.source = ./openssl;
    "nginx/site-enabled".source = ./nginx/site-enabled;
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # appendHttpConfig = ''
    #   include /etc/nginx/site-enabled/*;
    # '';

    # Add any further config to match your needs, e.g.:
    virtualHosts =
      let
        base = locations: {
          inherit locations;
          forceSSL = true;
          # enableACME = true;
          sslCertificate = "/etc/openssl/example.com.crt";
          sslCertificateKey = "/etc/openssl/example.com.key";
        };
        proxy = port:
          base {
            "/" = {
              proxyPass = "http://127.0.0.1:" + toString port + "/";
              proxyWebsockets = true;
              # extraConfig = "proxy_ssl_server_name on;" + "proxy_pass_header Authorization;";
            };
          };
      in
      {
        "example.com" = proxy 10811 // { default = true; };
      };
  };
}
