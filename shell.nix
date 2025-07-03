{
  pkgs,
  mkShell,
  ...
}:
mkShell rec {
  name = "hey-shell";
  meta.description = "Shell environment for hey with janet";

  buildInputs = with pkgs; [
    janet
  ];
  HEYENV = "{\"user\":\"linuxing3\",\"host\":\"laptop\",\"path\":\".\",\"theme\":\"autumnal\"}";

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
  INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;
  C_INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;
  CXX_INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;

  JANET_HEADERS_PATH = "${pkgs.janet}/include";
  JANET_TREE = "/home/linuxing3/.local/share/janet/jpm_tree";
  JANET_PATH = "/home/linuxing3/.local/share/janet/jpm_tree/lib";
  JANET_BUILD_PATH = "/home/linuxing3/.local/share/janet/jpm_tree/build";
  XDG_BIN_HOME = "/home/linuxing3/.local/bin";
  XDG_CONFIG_HOME = "/home/linuxing3/.config";
  XDG_DATA_HOME = "/home/linuxing3/.local/share";
  XDG_CACHE_HOME = "/home/linuxing3/.local/cache";
  XDG_STATE_HOME = "/home/linuxing3/.local/state";
  DOTFILES_HOME = "/home/linuxing3/sources/uni-nixos-config";
  packages = with pkgs; [
    just
    nixd
    janet
    jpm
  ];
}
