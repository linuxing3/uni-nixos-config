{pkgs, ...}: {
  home.packages = with pkgs; [
    alacritty-theme
  ];

  programs = {
    alacritty = {
      enable = true;

      settings = {
        window.dimensions = {
          lines = 3;
          columns = 200;
        };

        keyboard.bindings = [
          {
            key = "K";
            mods = "Control";
            chars = "\\u000c";
          }
        ];

        font = {
          normal.family = "JetBrainsMono Nerd Font";
          bold.family = "JetBrainsMono Nerd Font";
        };
      };
    };
  };
}
