{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.emacs;
  emacs-pkg = pkgs.emacs-pgtk;
  writer = pkgs.writeShellScriptBin "writer" ''
    if [ -z "$1" ]; then
      exec ${emacs-pkg}/bin/emacsclient --create-frame --alternate-editor ${emacs-pkg}/bin/emacs
    else
      exec ${emacs-pkg}/bin/emacsclient --alternate-editor ${emacs-pkg}/bin/emacs "$@"
    fi
  '';
in {
  services.emacs = {
    enable = true;
    package = emacs-pkg;
  };

  environment.systemPackages = [
    emacs-pkg
    writer
  ];

  environment.variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "writer");
}
