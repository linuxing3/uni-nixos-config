# templates
{inputs, ...}: {
  perSystem = {
    self',
    pkgs,
    ...
  }: let
    lib = import ../../lib {
      inherit (inputs) self;
      inherit pkgs;
      inherit (inputs.nixpkgs) lib;
    };
  in
    with builtins;
    with lib;
      mkFlake inputs {
        systems = ["x86_64-linux"];
        inherit lib;
        apps.install = mkApp ../../install.zsh;
        hosts = mapHosts ../../hosts;
        modules.starter = import ../..;
      };
}
