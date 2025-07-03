{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.files.flakeModules.default
  ];
  perSystem = {...}: {
    files.files = [
      {
        path_ = ".github/workflow/check";
        drv = pkgs.writers.writeJSON ".github/workflow/check.yaml" {
          on.push = {};
          jobs.check = {
            runs-on = "ubuntu-latest";
            steps = [
              {uses = "actions/checkout@v4";}
              {uses = "DeterminateSystems/nix-installer-action@main";}
              {uses = "DeterminateSystems/magic-nix-cache-action@main";}
              {run = "nix flake check";}
            ];
          };
        };
      }
    ];
  };
}
