{config, ...}: let
  alacrittyConfig = "${config.me.configPath}/alacritty";
in {
  xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink alacrittyConfig;
  programs.alacritty = {enable = true;};
}
