{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        font = wezterm.font("JetBrains Mono"),
        font_size = 16.0,
        color_scheme = "Tomorrow Night",
        hide_tab_bar_if_only_one_tab = true,
        default_prog = { "zsh", "--login", "-c", "zellij" },
        keys = {
          {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
        }
      }
    '';
  };
}
