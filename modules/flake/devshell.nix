{
  perSystem = {pkgs, ...}: let
    buildInputs = with pkgs; [
      janet
      janet.dev
      glibc
    ];
  in {
    devShells.default =
      pkgs.mkShell
      {
        name = "nixos-unified-template-shell";
        meta.description = "Shell environment for modifying this Nix configuration";

        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
        INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;
        C_INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;
        CXX_INCLUDE_PATH = pkgs.lib.makeIncludePath buildInputs;
        JANET_HEADERS_PATH = "${pkgs.janet.dev}/include";
        JANET_TREE = "$HOME/.local/share/janet/jpm_tree";
        JANET_PATH = "$JANET_TREE/lib";
        packages = with pkgs; [
          just
          nixd
          janet
          jpm
        ];
      };
  };
}
