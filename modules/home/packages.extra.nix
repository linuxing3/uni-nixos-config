{
  flake,
  pkgs,
  ...
}: let
  tile = pkgs.writeShellScriptBin "tile" ''
    cmd=$(which tmux)
    session=workspace
    $cmd has -t $session
    if [ $? != 0 ]; then
    	$cmd new -d -n yazi -s $session "yazi"
    	$cmd neww -n mail -t $session "neomutt"
    	$cmd neww -n zsh -t $session "zsh"
    	$cmd neww -n zsh -t $session "zsh"
    	$cmd selectw -t session:1
    fi
    $cmd att -t $session
    exit 0
  '';
  lfpick = pkgs.writeShellScriptBin "lfpick" ''
    TEMP=$(mktemp)
    lf --selection-path="$TEMP"
    cat "$TEMP"
  '';
in {
  home.sessionPath = [
    "$HOME/.bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.local/share/bin"
    "$HOME/.config/emacs/bin"
    ".git/safe/../../bin"
  ];
  home.packages = with pkgs; [
    tile
    lfpick

    just

    fish
    bash
    nushell

    foot
    alacritty
    wezterm

    ## CLI utility
    ani-cli
    aoc-cli # Advent of Code command-line tool
    binsider
    bitwise # cli tool for bit / hex manipulation
    caligula # User-friendly, lightweight TUI for disk imaging
    dconf-editor
    docfd # TUI multiline fuzzy document finder
    eza # ls replacement
    entr # perform action when file change
    fd # find replacement
    ffmpeg
    file # Show file information
    gtt # google translate TUI
    gifsicle # gif utility
    gtrash # rm replacement, put deleted files in system trash
    hexdump
    htop
    # imv # image viewer
    jq # JSON processor
    killall
    libnotify
    man-pages # extra man pages
    mimeo

    # useful tui tools
    tui-journal
    zellij
    calcurse
    neofetch
    parted
    putty
    socat
    xray
    shadowsocks-rust
    trojan-rs

    pandoc
    pandoc-plantuml-filter
    pandoc-drawio-filter

    plantuml

    present-cli

    mermaid-cli
    marksman

    comodoro
    pomodoro

    mpv # video player
    ncdu # disk space
    nitch # systhem fetch util
    nixd # nix lsp
    nixfmt-rfc-style # nix formatter
    openssl
    onefetch # fetch utility for git repo
    pamixer # pulseaudio command line mixer
    playerctl # controller for media players
    poweralertd
    programmer-calculator
    ripgrep # grep replacement
    shfmt # bash formatter
    swappy # snapshot editing tool
    tdf # cli pdf viewer
    treefmt # project formatter
    tldr
    todo # cli todo list
    toipe # typing test in the terminal
    ttyper # cli typing test
    unzip
    valgrind # c memory analyzer
    wavemon # monitoring for wireless network devices
    wl-clipboard # clipboard utils for wayland (wl-copy, wl-paste)
    wget
    woomer
    yt-dlp-light
    xdg-utils
    xxd
    libxkbcommon
    xorg.libxcb
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXrender
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xcb-util-cursor
    ntfs3g

    ## CLI
    cbonsai # terminal screensaver
    cmatrix
    pipes # terminal screensaver
    sl
    tty-clock # cli clock

    ## GUI Apps
    vscode-fhs
    vscode-langservers-extracted
    copilot-language-server-fhs

    zed-editor-fhs

    qutebrowser

    # audacity
    bleachbit # cache cleaner
    telegram-desktop
    filezilla
    # gimp
    gnome-disk-utility
    # ldtk # 2D level editor
    # tiled # tile map editor
    libreoffice
    nix-prefetch-github
    # obs-studio
    pavucontrol # pulseaudio volume controle (GUI)
    postman
    # pitivi                            # video editing
    gnome-calculator # calculator
    mission-center # GUI resources monitor
    soundwireserver
    # thunderbird
    vlc

    wine-wayland
    winetricks
    wineWowPackages.wayland
    zenity

    # C / C++
    clang
    clang-tools
    lldb

    # Node.js
    nodejs
    deno

    # Rust
    rustc
    cargo
    cargo-binstall

    # Zig
    zig
    zls

    # Python
    python3
    python312Packages.ipython

    alejandra
  ];
}
