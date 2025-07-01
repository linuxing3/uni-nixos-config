{
  flake,
  config,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  ghosttyPath = "${config.me.configPath}/ghostty";
  footConfig = "${config.me.configPath}/foot";
  weztermConfig = "${config.me.configPath}/wezterm";
  alacrittyConfig = "${config.me.configPath}/alacritty";
  tmuxConfig = "${config.me.configPath}/tmux";
in {
  home.packages = [inputs.ghostty.packages.${pkgs.system}.default];
  xdg.configFile."ghostty".source = config.lib.file.mkOutOfStoreSymlink ghosttyPath;

  programs = {
    foot.enable = true;
    nushell.enable = true;
    wezterm.enable = true;
    alacritty.enable = true;
  };

  xdg.configFile."foot".source = config.lib.file.mkOutOfStoreSymlink footConfig;
  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink weztermConfig;
  xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink alacrittyConfig;
  xdg.configFile."tmux".source = config.lib.file.mkOutOfStoreSymlink tmuxConfig;
}
