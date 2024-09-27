
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    fd
    fzf
    git
    htop
    btop
    jq
  ];
}

