{
  pkgs,
  config,
  lib,
  ...
}: {
  programs = {
    urxvt = {
      enable = false;
      keybindings = {
        "Shift-Control-C" = "eval:selection_to_clipboard";
        "Shift-Control-V" = "eval:paste_clipboard";
      };
      fonts = [
        "xft:JetBrainsMono Nerd Font:size=14:antialias=true:style=Regular"
        "xft:FiraCode Nerd Font:size=14:antialias=true:style=Regular"
        "xft:WenQuanYi Micro Hei Mono:size=14:antialias=true:style=Regular"
      ];
      scroll = {
        bar = {
          enable = false;
        };
      };
      transparent = true;
      extraConfig = {
        perl-ext-common = "default,clipboard,url-select,keyboard-select";
        shading = 15;
        fading = 40;
        internalBorder = 24;
        cursorBlink = true;
        saveLines = 2000;
        mouseWheelScrollPage = false;
        letterSpace = 0;
        lineSpace = 0;
        cursorUnderline = false;
        saveline = 2048;
        scrollBar = false;
        scrollBar_right = false;
        urgentOnBell = true;
        depth = 24;
        iso14755 = false;
      };
    };
  };
}
