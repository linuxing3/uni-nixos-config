{
  flake,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = flake.inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage =
      flake.inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  xdg.terminal-exec = {
    enable = true;
    package = pkgs.xdg-terminal-exec-mkhl;
    settings = let
      my_terminal_desktop = [
        # NOTE: We have add these packages at user level
        "Alacritty.desktop"
        "kitty.desktop"
        "foot.desktop"
        "com.mitchellh.ghostty.desktop"
      ];
    in {
      GNOME =
        my_terminal_desktop
        ++ [
          "com.raggesilver.BlackBox.desktop"
          "org.gnome.Terminal.desktop"
        ];
      niri = my_terminal_desktop;
      default = my_terminal_desktop;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
