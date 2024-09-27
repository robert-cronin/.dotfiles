{ config, pkgs, ... }:

{
  # Enable libvirtd Service
  virtualisation.libvirtd = {
    enable = true;
    # Configure QEMU/KVM settings
    qemu = {
      package = pkgs.qemu_kvm;
      # Enable OVMF for UEFI support
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
      # Enable Software TPM (optional, useful for Windows VMs)
      swtpm.enable = true;
    };
  };

  # User and Group Configuration
  # Create libvirt and kvm groups if they don't exist
  users.groups.libvirt = { };
  users.groups.kvm = { };

  # Add user 'rob' to libvirt and kvm groups
  users.users.rob = {
    extraGroups = [ "libvirt" "kvm" ];
  };

  # Enable virt-manager
  programs.virt-manager = {
    enable = true;
    package = pkgs.virt-manager;
  };

  # Install Additional virtualisation Tools
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    qemu_kvm
    libvirt
  ];
}

