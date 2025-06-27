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
      settings = {
        default_shell = "${pkgs.zsh}/bin/zsh";
        default_mode = "locked";
        pane_frames = false;
        simplified_ui = true;
        theme = "default";
        keybinds = {
          normal = {
            unbind = ["Ctrl g"];
          };
        };
      };
    };
  };

  home.sessionVariables = {
    TERM = "xterm-256color";
  };
  xdg.configFile."zellij".source = config.lib.file.mkOutOfStoreSymlink zellijPath;
}
