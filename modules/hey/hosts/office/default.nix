# laptop -- my primary powerhouse
{
  hey,
  lib,
  ...
}:
with lib;
with builtins; {
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

    desktop = {
      hyprland = rec {
        enable = false;
      };
      term.default = "foot";
      term.foot.enable = false;

      ## Extra
      apps.rofi.enable = false;
      apps.spotify.enable = false;
      apps.thunar.enable = false;
      apps.steam = {
        enable = false;
        libraryDir = "/media/windows/Program Files (x86)/Steam";
      };
      apps.godot.enable = false;

      browsers.default = "librewolf";
      browsers.librewolf.enable = false;
      media.cad.enable = false;
      media.daw.enable = false;
      media.graphics.enable = false;
      media.music.enable = false;
      media.video.enable = false;
      media.video.capture.enable = false;
      media.pdf.enable = false;
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
    networking.interfaces.eno1.useDHCP = false;

    # Disable all USB wakeup events to ensure restful sleep. This system has
    # many peripherals attached to it (shared between Windows and Linux) that
    # can unpredictably wake it otherwise.
    systemd.services.fixSuspend = {
      script = ''
        for ev in $(grep enabled /proc/acpi/wakeup | cut --delimiter=\  --fields=1); do
           echo $ev > /proc/acpi/wakeup
        done
      '';
      wantedBy = ["multi-user.target"];
    };

    # last partition as boot, device = "/dev/sdb2";
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/66F6-957D";
      fsType = "vfat";
    };

    # rootb: first partition ext4 as root
    # equal to `mount -t tmpfs tmpfs /`
    fileSystems."/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["relatime" "mode=755"];
    };

    # swap file instead of a particular swapswapDevices
    fileSystems."/swap" = {
      device = "/dev/disk/by-uuid/bc51540f-f085-44a3-ad6c-46bf2e138f6b";
      fsType = "btrfs";
      options = ["subvol=@swap" "rw"];
    };
    # remount swapfile in read-write mode
    fileSystems."/swap/swapfile" = {
      # the swapfile is located in /swap subvolume, so we need to mount /swap first.
      depends = ["/swap"];
      device = "/swap/swapfile";
      fsType = "none";
      options = ["bind" "rw"];
    };
    swapDevices = [
      {device = "/swap/swapfile";}
      # {device = "/dev/disk/by-uuid/f033c305-e649-4599-aa05-ccf352da4121";}
    ];

    # persistent
    fileSystems."/persistent" = {
      device = "/dev/disk/by-uuid/bc51540f-f085-44a3-ad6c-46bf2e138f6b";
      fsType = "btrfs";
      options = ["subvol=@persistent" "noatime" "compress-force=zstd:1"];
      neededForBoot = true;
    };
    # guix
    fileSystems."/gnu" = {
      device = "/dev/disk/by-uuid/bc51540f-f085-44a3-ad6c-46bf2e138f6b";
      fsType = "btrfs";
      options = ["subvol=@guix" "noatime" "compress-force=zstd:1"];
    };

    # tmp, cleared at boot
    fileSystems."/tmp" = {
      device = "/dev/disk/by-uuid/bc51540f-f085-44a3-ad6c-46bf2e138f6b";
      fsType = "btrfs";
      options = ["subvol=@tmp" "noatime" "compress-force=zstd:1"];
    };
  };
}
