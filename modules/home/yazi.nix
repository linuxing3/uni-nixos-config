{config, ...}: let
  yaziConfig = "${config.me.configPath}/yazi";
in {
  xdg.configFile."yazi".source = config.lib.file.mkOutOfStoreSymlink yaziConfig;
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}
