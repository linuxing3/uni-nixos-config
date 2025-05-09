{
  pkgs,
  config,
  ...
}: let
in {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    nerd-fonts.ubuntu-mono
    nerd-fonts.inconsolata
    nerd-fonts.droid-sans-mono

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    sarasa-gothic # 更纱黑体
    source-code-pro
    hack-font
    jetbrains-mono
    dejavu_fonts
    terminus_font
    twemoji-color-font
    fantasque-sans-mono
    # maple-mono
  ];
}
