{
  pkgs,
  config,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      autorun = false;
      layout = "us";
      xkbOptions = "caps:escape_shifted_capslock";
      desktopManager.runXdgAutostartIfNone = true;
      displayManager.gdm.enable = false;
      tty = 5;
      enableCtrlAltBackspace = true;
    };

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "linuxing3";
        };
        default_session = initial_session;
      };
    };
  };

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      rime-data
      librime
      fcitx5-rime
      fcitx5-chinese-addons
      fcitx5-nord
      fcitx5-material-color
    ];
  };
}
