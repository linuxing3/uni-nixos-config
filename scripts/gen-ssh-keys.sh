#!/usr/bin/env bash
# commit the changes after installing nixos successfully
git config --global user.email "linuxing3@qq.com"   # git-1
git config --global user.name "Xing Wenju"          # git-1
git commit -am "[feat] update hardware-configuration"

ssh-keygen -t ed25519 -a 256 -C "ryan@idols-ai" -f ~/.ssh/idols_ai
ssh-add ~/.ssh/idols_ai
