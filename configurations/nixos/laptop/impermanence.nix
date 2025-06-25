{
  flake,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.systemPackages = [
    # `sudo ncdu -x /`
    pkgs.ncdu
  ];

  # NOTE: impermanence only mounts the directory/file list below to /persistent
  # If the directory/file already exists in the root filesystem, you should
  # move those files/directories to /persistent first!
  environment.persistence."/persistent" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    # to hide them from the file manager
    hideMounts = true;
    directories = [
    ];
    files = [
    ];

    # the following directories will be passed to /persistent/home/$USER
    users.linuxing3 = {
      directories = [
        "OneDrive"
        "org"
        "tui-journal"
        "tmp"
        "soucres/mysecrets"

        "go"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }

        ".config/gh"

        ".config/zellij/layouts"
        ".config/zellij/theme"

        ".config/helix/icons"
        ".config/helix/actions"
        ".config/helix/scripts"
        ".config/helix/snippets"
        ".config/helix/tutors"
      ];
      files = [
        ".git-credentials"
        ".config/nushell/history.txt"
        ".config/sops/age/keys.txt"
        ".config/lf/icons"
      ];
    };
  };
}
