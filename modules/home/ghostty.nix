{
  flake,
  config,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  ghosttyPath = "${config.me.configPath}/ghostty";
in {
  home.packages = [inputs.ghostty.packages.${pkgs.system}.default];
  xdg.configFile."ghostty".source = config.lib.file.mkOutOfStoreSymlink ghosttyPath;
}
