{
  pkgs,
  config,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    displayManager.autoLogin = {
      enable = true;
      user = "linuxing3";
    };
    libinput = {
      enable = true;
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
