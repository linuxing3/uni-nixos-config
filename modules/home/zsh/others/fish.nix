{config, ...}: let
  fishPath = "${config.me.configPath}/fish";
  bashPath = "${config.me.configPath}/bash";
in {
  programs = {
    fish.enable = true;
    bash.enable = true;
  };

  xdg.configFile."fish".source = config.lib.file.mkOutOfStoreSymlink fishPath;
  xdg.configFile."bash".source = config.lib.file.mkOutOfStoreSymlink bashPath;
}
