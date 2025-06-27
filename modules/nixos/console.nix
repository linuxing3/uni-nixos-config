{pkgs, ...}: {
  # Enable automatic login for the user.
  services.getty = {
    # enable = false;
    autologinUser = "linuxing3";
  };
  # https://wiki.archlinux.org/title/KMSCON
  services.kmscon = {
    # Use kmscon as the virtual console instead of gettys.
    # kmscon is a kms/dri-based userspace virtual terminal implementation.
    # It supports a richer feature set than the standard linux console VT,
    # including full unicode support, and when the video card supports drm should be much faster.
    enable = true;
    autologinUser = "linuxing3";
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    extraOptions = "--term xterm-256color --xkb-options caps:escape_shifted_capslock --vt-term erase=^H";
    extraConfig = "font-size=16";
    # Whether to use 3D hardware acceleration to render the console.
    hwRender = true;
  };
}
