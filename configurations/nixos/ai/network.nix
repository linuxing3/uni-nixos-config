{pkgs, ...}: {
  networking = {
    hostName = "laptop";
    networkmanager.enable = true;
    interfaces.enp0s31f6.ipv4.addresses = [
      {
        address = "10.10.30.110";
        prefixLength = 24;
      }
    ];
    defaultGateway = "10.10.30.1";
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        631
        443
        59010
        59011
      ];
      allowedUDPPorts = [
        59010
        59011
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet

    neomutt

    mutt
    mutt-with-sidebar
    mutt-wizard

    notmuch
    notmuch-mutt

    getmail6
    fetchmail

    procmail
    maildrop

    w3m-full
    elinks

    offlineimap
    postfix
    postfixadmin

    fdm
    isync
    msmtp
  ];

  programs.msmtp = {
    enable = true;
    defaults = {
      aliases = "/etc/aliases";
    };
    accounts.default = {
      auth = true;
      tls = true;
      host = "smtp.qq.com";
      from = "linuxing3@qq.com";
      user = "linuxing3@qq.com";
      passwordeval = "cat /run/secrets/email/qq";
      aliases = "/etc/aliases";
    };
  };
  environment.etc = {
    "aliases" = {
      text = ''
        root: linuxing3@qq.com
      '';
      mode = "0644";
    };
  };
}
