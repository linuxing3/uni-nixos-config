{
  pkgs,
  # config,
  ...
}: let
  # tmuxPath = "${config.me.configPath}/tmux";
in {
  # xdg.configFile."tmux".source = config.lib.file.mkOutOfStoreSymlink tmuxPath;
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set-option -g prefix C-space
      unbind-key C-b
      bind-key C-Space send-prefix

      bind-key b set-option status

      bind-key -n M-r source-file ~/.config/tmux/tmux.conf \; \
             display-message "source-file done"

      bind-key Space command-prompt "new-window -n %1 'exec %1'"

      bind-key / command-prompt "split-window 'exec man %%'"
      bind-key S command-prompt "new-window -n %1 'ssh %1'"

      bind-key -n M-w kill-pane
      bind-key -n M-n new-window

      bind-key -n M-e new-window hx
      bind-key -n M-f new-window lf

      bind-key '|' split-window -h
      bind-key '-' split-window
      bind-key -n M-v split-window -h
      bind-key -n M-V split-window

      bind-key -n M-H previous-window
      bind-key -n M-L next-window

      bind-key -n M-m resize-pane -Z

      set-option -g mode-keys vi
      bind-key -n M-[ copy-mode
      bind-key -n M-] paste-buffer
    '';

    plugins = with pkgs; [
      tmuxPlugins.gruvbox
      # {
      #   plugin = tmuxPlugins.tmux-sidebar;
      #   extraConfig = ''
      #     set -g @plugin 'tmux-plugins/tmux-sidebar'
      #   '';
      # }
      # {
      #   plugin = tmuxPlugins.resurrect;
      #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      # }
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      # set -g @continuum-restore 'on'
      # set -g @continuum-save-interval '60' # minutes
      #   '';
      # }
    ];
  };
}
