# templates
{
  inputs,
  pkgs,
  ...
}: let
  lib = import ../../lib {
    inherit (inputs) self;
    inherit pkgs;
    inherit (inputs.nixpkgs) lib;
  };
in {
  perSystem = {
    self',
    pkgs,
    ...
  }: {
    # systems = ["x86_64-linux"];
    # inherit lib;
    # apps.install = mkApp ../../install.zsh;
    # hosts = mapHosts ../../hosts;
    # modules.starter = import ../..;
  };
}
