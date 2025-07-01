{...}: {
  imports = [
    ./zsh.nix
    ./zsh_alias.nix
    ./zsh_keybinds.nix
    # other shells
    ./others/nushell.nix
    ./others/fish.nix
  ];
}
