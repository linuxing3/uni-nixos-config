{
  pkgs,
  config,
  ...
}: {
  programs.gh = {
    enable = true;
    settings = {
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
      editor = "hx";
      git-protocol = "ssh";
    };
    gitCredentialHelper = {
      enable = true;
      hosts = [
        "https://github.com"
        "https://gist.github.com"
        "https://gitlab.com"
        "https://gitee.com"
      ];
    };
  };

  programs.git = {
    enable = true;

    userName = "${config.me.username}";
    userEmail = "${config.me.email}";

    # 对于大多数个人用户，GPG 或 SSH 会是对提交进行签名的最佳选择。
    # 在较大型组织的环境中通常需要 S/MIME 签名。
    # SSH 签名是最容易生成的。 甚至可以将现有身份验证密钥上传到 GitHub 以用作签名密钥。
    # 生成 GPG 签名密钥比生成 SSH 密钥更复杂，但 GPG 具有 SSH 所没有的功能。
    # GPG 密钥可以在不再使用时过期或撤销。 GPG 签名可能包含其已过期或被撤销的信息。
    # signing with gpg
    signing = {
      signer = "${pkgs.gnupg}/bin/gpg";
      key = "2B59141EA701C49F";
      format = "openpgp";
      signByDefault = true;
    };
    # signing with ssh
    # signing = {
    #   signer = "${pkgs.openssh}/bin/ssh";
    #   format = "ssh";
    #   key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOm5HPR9bV+g/kWwDLzBCgCIija6GnHseUEthM+vX40l linuxing3@qq.com";
    #   signByDefault = true;
    # };

    ignores = [
      "*~"
      "*.swp"
      ".direnv"
      ".devenv"
      ".build"
      "/result*"
      "/build/"
      "*.zwc"
    ];

    includes = [
      {path = "~/${config.me.username}-dotfiles/git/extra-config.inc";}
      {
        path = "~/${config.me.username}-dotfiles/git/nixos-extra-config.inc";
        condition = "gitdir:~/sources/uni-nixos-config";
      }
    ];

    extraConfig = {
      init.defaultBranch = "main";
      # credential.helper = "store";
      # credential.helper = "/etc/profiles/per-user/${config.me.username}/bin/gh auth git-credential";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      core = {
        whitespace = "trailing-space,space-before-tab";
      };
      url."ssh://git@github.com".insteadOf = "https://github.com";
    };

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = true;
        diff-so-fancy = true;
        navigate = true;
      };
    };
  };

  home.packages = [pkgs.gh]; # pkgs.git-lfs

  programs.zsh.shellAliases = {
    g = "lazygit";
    gf = "onefetch --number-of-file-churns 0 --no-color-palette";
    ga = "git add";
    gaa = "git add --all";
    gs = "git status";
    gb = "git branch";
    gm = "git merge";
    gd = "git diff";
    gpl = "git pull";
    gplo = "git pull origin";
    gps = "git push";
    gpso = "git push origin";
    gpst = "git push --follow-tags";
    gcl = "git clone";
    gc = "git commit";
    gcm = "git commit -m";
    gcma = "git add --all && git commit -m";
    gtag = "git tag -ma";
    gch = "git checkout";
    gchb = "git checkout -b";
    glog = "git log --oneline --decorate --graph";
    glol = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'";
    glola = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all";
    glols = "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat";
  };
}
