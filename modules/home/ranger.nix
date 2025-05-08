{
  inputs,
  # pkgs,
  ...
}: {
  programs.ranger = {
    enable = true;
    settings = {
      column_ratios = "1,3,3";
      confirm_on_delete = "never";
      unicode_ellipsis = true;
      scroll_offset = 8;
      status_bar_on_top = false;
      draw_borders = "both";
      dirname_in_tabs = true;
      mouse_enabled = true;
      display_free_space_in_status_bar = true;
      autosave_bookmarks = true;
      sort = "natural";
      cd_bookmarks = true;
    };
    aliases = {
      e = "edit";
      setl = "setlocal";
      q = "quit";
      qa = "quitall";
      qall = "quitall";
      filter = "scout -prts";
    };
    mappings = {
      Q = "quitall";
      q = "quit";
      "<F1>" = "help";
      "<F2>" = "rename_append";
      "<F3>" = "display_file";
      "<F4>" = "edit";
      "<F5>" = "copy";
      "<F6>" = "cut";
      "<F7>" = "console mkdir%space";
      "<F8>" = "console delete";
      "<F10>" = "exit";
      "<C-n>" = "tab_new";
      "<C-w>" = "tab_close";
      "<TAB>" = "tab_move 1";
      "<S-TAB>" = "tab_move -1";
      "<A-Right>" = "tab_move 1";
      "<A-Left>" = "tab_move -1";
      "gt" = "tab_move 1";
      "gT" = "tab_move -1";
      "gn" = "tab_new";
      "gc" = "tab_close";
      "uq" = "tab_restore";
    };
    extraConfig = ''
      set colorscheme solarized

      set preview_files true
      set preview_directories true
      set collapse_preview true
      set draw_borders both

      # VIM-like
      copymap <UP>       k
      copymap <DOWN>     j
      copymap <LEFT>     h
      copymap <RIGHT>    l
      copymap <HOME>     gg
      copymap <END>      G
      copymap <PAGEDOWN> <C-F>
      copymap <PAGEUP>   <C-B>
    '';
    rifle = [
      {
        condition = "mime ^text, label editor";
        command = ''hx -- "$@"'';
      }
      {
        condition = "mime ^text, label pager";
        command = ''bat -- "$@"'';
      }
    ];
  };
}
