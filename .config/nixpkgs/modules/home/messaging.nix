{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    slack
    discord
    telegram-desktop
  ];
}

