{flake, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      manager = {
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_dir_first = true;
        sort_reverse = false;
        sort_sensitive = false;
      };
    };

    # keymap = {
    #   mgr.prepend_keymap = [
    #     {
    #       run = "escape";
    #       on = ["<Esc>"];
    #     }
    #     {
    #       run = "quit";
    #       on = ["q"];
    #     }
    #     {
    #       run = "close";
    #       on = ["<C-q>"];
    #     }
    #   ];
    # };

    plugins = {
      full-border = "${flake.inputs.yazi-plugins}/full-border.yazi";
      smart-enter = "${flake.inputs.yazi-plugins}/smart-enter.yazi";
      chmod = "${flake.inputs.yazi-plugins}/chmod.yazi";
      git = "${flake.inputs.yazi-plugins}/git.yazi";
      diff = "${flake.inputs.yazi-plugins}/diff .yazi";
      mount = "${flake.inputs.yazi-plugins}/mount.yazi";
    };
  };

  # initLua = ./init.lua;
  xdg.configFile."yazi/init.lua".text = ''
    require("full-border"):setup{
      type = ui.Border.ROUNDED,
    }
    require("git"):setup()
    require("smart-enter"):setup{
      open_multi = true,
    }
  '';
}
