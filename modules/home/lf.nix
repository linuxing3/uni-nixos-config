{config, ...}: let
  lfPath = "${config.me.configPath}/lf";
in {
  programs.lf = {
    enable = true;
  };
  xdg.configFile."lf".source = config.lib.file.mkOutOfStoreSymlink lfPath;

  programs.pistol.enable = true;
}
