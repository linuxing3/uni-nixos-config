{
  flake,
  pkgs,
  ...
}: {
  home.packages = (
    with pkgs; [
      flake.inputs.zen-browser.packages."${system}".default
      # pkgs.librewolf
    ]
  );
}
