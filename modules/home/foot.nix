{...}: {
  programs.foot = {
    enable = true;

    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono:size=14";
        dpi-aware = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
