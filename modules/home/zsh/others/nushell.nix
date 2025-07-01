{config, ...}: let
  nushellPath = "${config.me.configPath}/nushell";
in {
  programs = {
    nushell.enable = true;
  };

  xdg.configFile."nushell".source = config.lib.file.mkOutOfStoreSymlink nushellPath;
}
