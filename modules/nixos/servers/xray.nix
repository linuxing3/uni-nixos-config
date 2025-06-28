{

  services.xray = {
    enable = true;
    settings = {
      inbounds = [
        {
          listen = "127.0.0.1";
          port = 10811;
          protocol = "http";
        }
        {
          port = 10810;
          listen = "127.0.0.1";
          protocol = "socks";
          sniffing = {
            enabled = true;
            destOverride = [
              "http"
              "tls"
            ];
          };
          settings = {
            auth = "noauth";
            udp = false;
          };
        }
      ];
      outbounds = [
        {
          protocol = "vmess";
          settings = {
            vnext = [
              {
                address = "119.12.171.225";
                port = 443;
                users = [
                  {
                    id = "abe98b93-bd82-432f-8a41-0328a8aa5f5a";
                    alterId = 64;
                  }
                ];
              }
            ];
          };
          streamSettings = {
            network = "ws";
            security = "tls";
            tlsSettings = {
              allowInsecure = true;
              serverName = "example.com";
            };
            wsSettings = {
              path = "/mm909623";
              headers = {
                Host = "example.com";
              };
            };
          };
        }
      ];
    };

  };

}
