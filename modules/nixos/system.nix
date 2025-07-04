{
  pkgs,
  flake,
  ...
}: {
  # imports = [ inputs.nix-gaming.nixosModules.default ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        # "https://nix-gaming.cachix.org"
        "https://hyprland.cachix.org"
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://ghostty.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        # "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
      extra-substituters = [
        "https://anyrun.cachix.org"
      ];
      extra-trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
  };
  nixpkgs = {
    overlays = [
      flake.inputs.nur.overlays.default

      # inputs.nixpkgs-wayland.overlay

      # (import (builtins.fetchTarball {
      #   url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      #   sha256 = "0d9f082m4lfcmgcn461avhymk90pfgprp1ckwpgvck91npy0xvk9";
      # }))
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}
