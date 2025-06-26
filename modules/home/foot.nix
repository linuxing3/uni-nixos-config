{config, ...}: let
  footConfig = "${config.me.configPath}/foot";
in {
  xdg.configFile."foot".source = config.lib.file.mkOutOfStoreSymlink footConfig;
  programs.foot = {
    enable = true;
  };
}
