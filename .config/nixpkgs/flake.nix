{
  description = "NixOS and Home Manager configuration for Rob";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # NixOS System Configuration for Rob
      nixosConfigurations.rob = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./modules/sys/virt.nix
          ./modules/sys/systools.nix
          # ./modules/sys/kubernetes.nix
        ];
      };

      # Home Manager User Configuration for Rob
      homeConfigurations.rob = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./modules/home/obsidian.nix
          ./modules/home/office.nix 
          ./modules/home/messaging.nix
          ./modules/home/containers.nix
        ];
      };
    };
}


