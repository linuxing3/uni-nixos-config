{...}: {
  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
    __GL_GSYNC_ALLOWED = 0;
    __GL_VRR_ALLOWED = 0;
    _JAVA_AWT_WM_NONEREPARENTING = 1;
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    DISABLE_QT5_COMPAT = 0;
    GDK_BACKEND = "wayland";
    ANKI_WAYLAND = 1;
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = 1;
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    MOZ_ENABLE_WAYLAND = 1;
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = 1;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GTK_THEME = "Colloid-Green-Dark-Gruvbox";
    GRIMBLAST_HIDE_CURSOR = 0;
  };
  home.shellAliases = {
    "..." = "cd ../..";
    "noproxy" = "export HTTPS_PROXY=;export HTTP_PROXY=";
    xp = "kitty tmuxp load ~/.config/tmux/dev.yml";
    xh = "hyprctl reload";
    xn = "nh os switch";
    j = "just";
    jr = "just run";
    jb = "just build";
    st = "nix-shell -p xst.out --run xst > /dev/null 2>&1";
    ec = "emacsclient -r -nw";
    es = "emacs --daemon";
    zj = "zellij";
    fz = "footclient zellij";
    ft = "footclient tmux";
    fy = "footclient yazi";
    fl = "footclient lf";
  };
}
