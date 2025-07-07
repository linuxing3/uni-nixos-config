# laptop -- my primary powerhouse
{
  hey,
  lib,
  ...
}:
with lib;
with builtins; {
  imports = [./hardware-configuration.nix];

  system = "x86_64-linux";

  modules = {
    theme.active = "autumnal";
    xdg.ssh.enable = true;

    profiles = {
      role = "workstation";
      user = "linuxing3";
      networks = ["ca"];
      hardware = [
        "ssd"
        "bluetooth"
      ];
    };

    dev = {
      cc.enable = true;
    };
    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };
    shell = {
      vaultwarden.enable = false;
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
    services = {
      ssh.enable = true;
      # docker.enable = false;
    };
    system = {
      utils.enable = true;
      fs.enable = true;
    };
    # virt.qemu.enable = false;
  };

  ## local config
  config = {pkgs, ...}: {
    networking.search = ["dev.efwmc.org"];

    user.packages = with pkgs; [
      helix
      zellij
      tmux
    ];
  };

  hardware = {...}: {
    networking = {
      hostName = "office";
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
  };
}
