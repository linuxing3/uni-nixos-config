let
  ai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFFJhk/T6xIHJBLLN4Z3SQ/O8eR0etXCihNM5KFw3UB9 root@ai";
  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDEXxlw9m+JTZAWk0nNkZhBgcG1PJ4v9f9qBX96PxfMm root@laptop";
  linuxing3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkEAydXSknuL8JZBeiCjesQy43wlszNVqDHyGDRCDCX linuxing3@ai";
  linuxing3-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOm5HPR9bV+g/kWwDLzBCgCIija6GnHseUEthM+vX40l linuxing3@qq.com";
  linuxing3-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOm5HPR9bV+g/kWwDLzBCgCIija6GnHseUEthM+vX40l linuxing3@qq.com";
  users = [linuxing3 linuxing3-1 linuxing3-2];
  systems = [ai laptop];
in {
  "username.age".publicKeys = users ++ systems;
  "fullname.age".publicKeys = users ++ systems;
  "deepseek-token.age".publicKeys = users ++ systems;
  "gemini-token.age".publicKeys = users ++ systems;
  "mail-outlook.age".publicKeys = users ++ systems;
  "mail-gmail.age".publicKeys = users ++ systems;
  "mail-mfa.age".publicKeys = users ++ systems;
  "mail-qq.age".publicKeys = users ++ systems;
  "nix-generic-pass.age".publicKeys = users ++ systems;
  "nix-access-tokens.age".publicKeys = users ++ systems;
  "nix-vm-pass.age".publicKeys = users ++ systems;
  "caddy-key.age".publicKeys = users ++ systems;
  "nginx-key.age".publicKeys = users ++ systems;
  "postgres-url.age".publicKeys = users ++ systems;
  "gh-token.age".publicKeys = users ++ systems;
  "gh-cli-token.age".publicKeys = users ++ systems;
  "gh-personal-token.age".publicKeys = users ++ systems;
  "gh-recovery.age".publicKeys = users ++ systems;
  "netlify-recovery.age".publicKeys = users ++ systems;
  "default-gpg.age".publicKeys = users ++ systems;
  "default-gpg-key.age".publicKeys = users ++ systems;
  "gist-token.age".publicKeys = users ++ systems;
  "mail-qq-pass.age".publicKeys = users ++ systems;
  "mail-mfa-pass.age".publicKeys = users ++ systems;
  "cachix-auth-token.age".publicKeys = users ++ systems;
}
