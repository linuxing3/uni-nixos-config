{config, ...}: let
  bashPath = "${config.me.configPath}/bash";
in {
  programs = {
    fish.enable = true;
    bash.enable = true;
  };

  xdg.configFile."bash".source = config.lib.file.mkOutOfStoreSymlink bashPath;
}
