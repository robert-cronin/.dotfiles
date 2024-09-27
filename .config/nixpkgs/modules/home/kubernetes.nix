{ config, pkgs, lib, ... }:

with lib;

let
  kubernetesTools = [
    pkgs.minikube
    pkgs.kind
    pkgs.kubectl
  ];
in {
  options = {
    services.kubernetes = {
      enable = mkEnableOption "Enable Kubernetes tools (Minikube, Kind, kubectl)";
      
      minikube.enable = mkEnableOption "Enable Minikube";
      kind.enable = mkEnableOption "Enable Kind";
      kubectl.enable = mkEnableOption "Enable kubectl";
    };
  };

  config = mkIf config.services.kubernetes.enable {
    # Enable Docker service required by Kind and optionally by Minikube
    services.docker.enable = true;

    # Add Kubernetes tools to system packages
    environment.systemPackages = lib.mkIf config.services.kubernetes.enable kubernetesTools;

    # Add user to the docker group for managing Docker without sudo
    users.users.rob = {
      extraGroups = [ "docker" ];
    };

    # Optionally, configure Home Manager for user-specific Kubernetes tools
    # This assumes Home Manager is already integrated
    home-manager.users.rob = mkIf config.home-manager?.users?.rob.kubernetes?.enable {
      home.packages = config.home-manager.users.rob.kubernetes.packages or [];
    };
  };
}

