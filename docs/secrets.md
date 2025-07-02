# Secrets Management

This document explains how to manage secrets in your NixOS configuration
using `agenix`,`sops-nix` and `gpg` tools

## Prerequisites

1. Install required tools:
   ```bash
   nix-shell -p agenix sops age gpg
   ```

2. Add to your flake.nix inputs:

   ```nix
   inputs.agenix.url = "github:ryantm/agenix";
   inputs.sops-nix.url = "github:Mic92/sops-nix";
    # my private secrets, it's a private repository, you need to replace it with your own.
    # use ssh protocol to authenticate via ssh-agent/ssh-key, and shallow clone to save time
   inputs.mysecrets = {
      url = "git+ssh://git@github.com/linuxing3/mysecrets.git?shallow=1";
      flake = false;
    };
   ```
3. Privete Repo `/home/linuxing3/sources/mysecrets` directory tree


├── age
│   └── keys.txt
├── agenix
├── cachix-auth-token.age
├── caddy-key.age
├── deepseek-token.age
├── default-gpg.age
├── default-gpg-key.age
├── fullname.age
├── gemini-token.age
├── gh-cli-token.age
├── gh-personal-token.age
├── gh-recovery.age
├── gh-token.age
├── mail-gmail.age
├── mail-mfa.age
├── mail-mfa-pass.age
├── mail-outlook.age
├── mail-qq.age
├── mail-qq-pass.age
├── netlify-recovery.age
├── nginx-key.age
├── nix-access-tokens.age
├── nix-generic-pass.age
├── nix-vm-pass.age
├── password.yaml
├── postgres-url.age
├── public
│   ├── efwmc.pub
│   ├── linuxing3-gpg-keys-2025-07-01.pub
│   └── romantic.pub
├── secrets.nix
└── username.age

3 directories, 31 files

## Secrets Management

### Agenix Secrets Management

> All the operations in this section should be performed in my private repository: `mysecrets`.

1. Create/edit `secrets.nix` to define your secrets:
   ```nix
   let
     user = "some_user_public_key";
     system = "some_system_public_key";
   in
   {
     "email/mfa.age".publicKeys = [ age1 ];
   }
   ```

2. Create a new secret:

This task is accomplished using the [agenix](https://github.com/ryantm/agenix) CLI tool with the
`./secrets.nix` file, so you need to have it installed first:

   ```bash
   nix shell github:ryantm/agenix#agenix
   agenix -e email/mfa.age -i ~/.ssh/some_private_key
   ```

3. Use new secret in `uni-nixos-config` Repo:

Then, create `./secrets/default.nix` with the following content:

```nix
# import & decrypt secrets in `mysecrets` in this module
{ config, pkgs, flake,  ... }:
let
  inherit (flake) inputs;
  inherit (inputs) mysecrets;
in
{
  imports = [
     agenix.nixosModules.default
  ];

  # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
  age.identityPaths = [
    # using the host key for decryption
    # the host key is generated on every host locally by openssh, and will never leave the host.
    "/etc/ssh/ssh_host_ed25519_key"
    "~/.ssh/some_user_private_key"
  ];

  age.secrets."xxx" = {
    # whether secrets are symlinked to age.secrets.<name>.path
    symlink = true;
    # target path for decrypted file, default `/run/agenix`
    path = "/etc/secrets/";
    # encrypted file path
    file =  "${mysecrets}/xxx.age";  # refer to ./xxx.age located in `mysecrets` repo
    mode = "0400";
    owner = "root";
    group = "root";
  };
}
```

From now on, every time you run `nixos-rebuild switch`, it will decrypt the secrets using the
private keys defined in `age.identityPaths`. It will then symlink the secrets to the path defined by
the `age.secrets.<name>.path` argument, which defaults to `/etc/secrets` (aka `/run/agenix`).

## Adding a new host

1. `cat` the system-level public key(`/etc/ssh/ssh_host_ed25519_key.pub`) of the new host, and send
   it to an old host which has already been configured.
2. On the old host:
   1. Add the public key to `secrets.nix`, and rekey all the secrets via
      `sudo agenix -r -i /etc/ssh/ssh_host_ed25519_key`.
   2. Commit and push the changes to `nix-secrets`.
3. On the new host:
   1. Clone this repo and run `nixos-rebuild switch` to deploy it, all the secrets will be decrypted
      automatically via the host private key.

### Using sops-nix

1. Create/edit `password.yaml` as plain data
   ```yaml
   email:
     mfa: ENC[AES256_GCM...]
   ```

2. Generate new secrets in place:
   ```bash
   sops --encrypt --in-place password.yaml
   ```

#### Mail Account Example

See `modules/home/mail/getmail.nix` for a complete example. Key parts:

```nix
passwordCommand = "cat /run/secrets/email/mfa";
```

The secret is referenced in the mail configuration while the actual value is securely stored.

#### Environment Variables

For environment variables, use direnv (see `modules/home/direnv.nix`):

1. Create `.envrc`:
   ```bash
   echo "export SECRET_VALUE=$(cat /run/secrets/my_secret)" > .envrc
   direnv allow
   ```

2. Or use directly in Nix:
   ```nix
   environment.sessionVariables = {
     MY_SECRET = "$(cat /run/secrets/my_secret)";
   };
   ```

### GPG Secrets Management

#### Generate your own gpg store

1. Generate with full process

```bash
gpg --full-generate-key
```
2. List keys and find keyid

```bash
gpg --list-secret-keys --keyid-format=long
```

3. Export public key with keyid

```bash
gpg --armor --export 2B59141EA701C49F
```

4. Checks other keys

```bash
gpg --list-public-keys
gpg --list-signatures
```

#### Using it in `github`

1. Make sure to add gpg keys to `github` profile settings

2. Run `gh auth login` to generate your own gh auth data `~/.config/gh/hosts.yml`

```yml
github.com:
    users:
        linuxing3:
            oauth_token: gho_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    git_protocol: https
    user: linuxing3
    oauth_token: gho_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

```

3. Configure your `~/.config/git/config` (can be done with nix module)

```toml
[commit]
	gpgSign = true

[core]
	pager = "/nix/store/a01vzfhkzfhp5sqdq5pxk6b60sf7lj7v-delta-0.18.2/bin/delta"
	whitespace = "trailing-space,space-before-tab"

[credential "https://gist.github.com"]
	helper = "/nix/store/aapnxgvkl1xx1s13c93k8d18f3vlg9r0-gh-2.72.0/bin/gh auth git-credential"

[credential "https://gitee.com"]
	helper = "/nix/store/aapnxgvkl1xx1s13c93k8d18f3vlg9r0-gh-2.72.0/bin/gh auth git-credential"

[credential "https://github.com"]
	helper = "/nix/store/aapnxgvkl1xx1s13c93k8d18f3vlg9r0-gh-2.72.0/bin/gh auth git-credential"

[credential "https://gitlab.com"]
	helper = "/nix/store/aapnxgvkl1xx1s13c93k8d18f3vlg9r0-gh-2.72.0/bin/gh auth git-credential"

[delta]
	diff-so-fancy = true
	line-numbers = true
	navigate = true
	side-by-side = true

[diff]
	colorMoved = "default"

[gpg]
	format = "openpgp"

[gpg "openpgp"]
	program = "/nix/store/wfsqj2kiqsnrp24gjfrw2bprrmzca31i-gnupg-2.4.7/bin/gpg"

[init]
	defaultBranch = "main"

[interactive]
	diffFilter = "/nix/store/a01vzfhkzfhp5sqdq5pxk6b60sf7lj7v-delta-0.18.2/bin/delta --color-only"

[merge]
	conflictstyle = "diff3"

[sendemail "mfa"]
	envelopeSender = "auto"
	from = "Xing Wenju <xing_wenju@mfa.gov.cn>"
	sendmailCmd = "/nix/store/rk38jlvyc5cxf5xi85791yf81azyj8kf-msmtp-1.8.26/bin/msmtp"

[sendemail "qq"]
	envelopeSender = "auto"
	from = "Xing Wenju <linuxing3@qq.com>"
	sendmailCmd = "/nix/store/rk38jlvyc5cxf5xi85791yf81azyj8kf-msmtp-1.8.26/bin/msmtp"

[tag]
	gpgSign = true

[url "ssh://git@github.com"]
	insteadOf = "https://github.com"

[user]
	email = "linuxing3@qq.com"
	name = "linuxing3"
	signingKey = "2B59141EA701C49F"

[include]
	path = "~/linuxing3-dotfiles/git/extra-config.inc"

[includeIf "gitdir:~/sources/uni-nixos-config"]
	path = "~/linuxing3-dotfiles/git/nixos-extra-config.inc"
```

Then just use `git` and `gh` as normal

## Best Practices

1. Never commit unencrypted secrets
2. Use different keys for different environments
3. Rotate secrets regularly
4. Limit access to secret files
5. Use `chmod 600` for secret files
6. Document all secret locations and purposes
