
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    distrobox
    trivy
  ];
}

