{ config, pkgs, ... }:

{
  # Programs Configuration
  programs.neovim = {
    package = pkgs.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  # User and Home Directory Configuration
  home.username = "rob";
  home.homeDirectory = "/home/rob";

  # State Version
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Packages
  home.packages = with pkgs; [
    gcc
    git
    nerdfonts
    gh
    ripgrep
    fzf
    tmux
    zsh
    httpie
    unzip
    jq
    lazygit
    delve
    go-task
    hugo
    spotify
    qbittorrent
    zoxide
    bat
    fd
    kubectl

    # Override nerdfonts to use only "Meslo"
    (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
  ];

  # Managed Files (Optional)
  home.file = {
    # Example:
    # ".screenrc".source = ./dotfiles/screenrc;
  };

  # Environment Variables (Optional)
  home.sessionVariables = {
    # Example:
    # EDITOR = "vim";
  };

  # Enable Home Manager
  programs.home-manager.enable = true;

  # Dconf Settings for Virt-Manager
  dconf.settings."org/virt-manager/virt-manager/connections" = {
    autoconnect = [ "qemu:///system" ];
    uris = [ "qemu:///system" ];
  };
}

