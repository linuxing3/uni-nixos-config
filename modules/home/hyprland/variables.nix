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
    XDG_BIN_HOME = "/home/linuxing3/.local/bin";
    XDG_CONFIG_HOME = "/home/linuxing3/.config";
    XDG_DATA_HOME = "/home/linuxing3/.local/share";
    XDG_CACHE_HOME = "/home/linuxing3/.local/cache";
    XDG_STATE_HOME = "/home/linuxing3/.local/state";
    DOTFILES_HOME = "/home/linuxing3/sources/uni-nixos-config";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GTK_THEME = "Colloid-Green-Dark-Gruvbox";
    GRIMBLAST_HIDE_CURSOR = 0;
    EDITOR = "hx";
    VISUAL = "hx";
    LF_BOOKMARK_PATH = "~/OneDrive/lf_bookmark";
  };
  home.shellAliases = {
    "..." = "cd ../..";
    xh = "hyprctl reload";
    xn = "nh os switch";
    j = "just";
    zj = "zellij";
  };
}
