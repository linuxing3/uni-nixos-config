# Secrets Management

This document explains how to manage secrets in your NixOS configuration using both `agenix` and `sops-nix`.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Creating Secrets](#creating-secrets)
- [Using Secrets](#using-secrets)
  - [Mail Account Example](#mail-account-example)
  - [Environment Variables](#environment-variables)
- [Best Practices](#best-practices)

## Prerequisites

1. Install required tools:
   ```bash
   nix-shell -p agenix sops age
   ```

2. Add to your flake.nix inputs:
   ```nix
   inputs.agenix.url = "github:ryantm/agenix";
   inputs.sops-nix.url = "github:Mic92/sops-nix";
   ```

## Creating Secrets

### Using agenix

1. Create/edit secrets.nix to define your secrets:
   ```nix
   let
     user = "your_username";
     system = "x86_64-linux";
   in
   {
     "email/mfa.age".publicKeys = [ "age1..." ];
   }
   ```

2. Create a new secret:
   ```bash
   agenix -e email/mfa.age
   ```

### Using sops-nix

1. Create/edit secrets.yaml (like password.yaml):
   ```yaml
   email:
     mfa: ENC[AES256_GCM...]
   ```

2. Generate new secrets:
   ```bash
   sops --encrypt --in-place password.yaml
   ```

## Using Secrets

### Mail Account Example

See `modules/home/mail/getmail.nix` for a complete example. Key parts:

```nix
passwordCommand = "cat /run/secrets/email/mfa";
```

The secret is referenced in the mail configuration while the actual value is securely stored.

### Environment Variables

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

## Best Practices

1. Never commit unencrypted secrets
2. Use different keys for different environments
3. Rotate secrets regularly
4. Limit access to secret files
5. Use `chmod 600` for secret files
6. Document all secret locations and purposes
