{config, ...}: let
  # path to your zellij config directory
  zellijPath = "${config.me.configPath}/zellij";
in {
  programs = {
    zellij = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
  home.sessionVariables = {
    TERM = "xterm-256color";
  };
  xdg.configFile."zellij".source = config.lib.file.mkOutOfStoreSymlink zellijPath;
}
