{ config, pkgs, ... }:

{
  imports =
    [
       # <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Add Tailscale
  services.tailscale.enable = true;

  # Enable ExpressVPN
  services.expressvpn = {
    enable = true;
  };

  # Ensure the firewall is enabled
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Ensure that the ExpressVPN activation data persists
  environment.etc."expressvpn".source = "/var/lib/expressvpn";

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with PipeWire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rob = {
    isNormalUser = true;
    description = "rob";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirt" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    google-chrome
    git
    zsh
    alacritty

    # Dev tools
    tmux
    vim
    neovim

    # Languages
    go
    nodejs

    docker-compose
  ];

  # Docker config
  virtualisation = {
    docker.enable = true;
  };

  # Set the default shell to zsh
  programs.zsh.enable = true;
  # users.defaultUserShell = pkgs.zsh; # Already set in users.users.rob.shell

  # Enable using flakes
  nix.settings = {
    experimental-features = "flakes nix-command";
  };

  # Programs requiring SUID wrappers
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # State Version
  system.stateVersion = "24.05";
}

