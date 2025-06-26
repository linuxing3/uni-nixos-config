{config, ...}: let
  # path to your zellij config directory
  helixPath = "/persistent/home/linuxing3/.config/helix";
in {
  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink helixPath;

  programs = {
    zellij = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}
