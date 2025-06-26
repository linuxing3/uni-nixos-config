{
  pkgs,
  config,
  ...
}: let
  # path to your helix config directory
  helixPath = "${config.me.configPath}/helix";
in {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      marksman
      markdown-oxide
      markdownlint-cli
      helix-gpt
    ];
  };
  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink helixPath;
}
