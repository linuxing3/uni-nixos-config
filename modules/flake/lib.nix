# templates
{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    ...
  }: let
    lib = import ../../lib {
      inherit self';
      inherit pkgs;
      inherit (inputs.nixpkgs) lib;
    };
  in
    with builtins;
    with lib;
      mkFlake inputs {
        inherit lib;
        apps.install = mkApp ../../install.zsh;
      };
}
