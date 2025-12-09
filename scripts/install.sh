#!/usr/bin/env bash
# ============================================
# Dotfiles Installer - Cross-Platform
# Supports: Ubuntu/Debian, Arch, Fedora, macOS
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Banner
echo -e "${PURPLE}"
cat << "EOF"
    ____        __  _____ __
   / __ \____  / /_/ __(_) /__  _____
  / / / / __ \/ __/ /_/ / / _ \/ ___/
 / /_/ / /_/ / /_/ __/ / /  __(__  )
/_____/\____/\__/_/ /_/_/\___/____/

EOF
echo -e "${NC}"
echo -e "${CYAN}Cross-Platform Installer${NC}"
echo ""

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MANAGER="brew"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|pop|linuxmint)
                OS="debian"
                PKG_MANAGER="apt"
                ;;
            arch|manjaro|endeavouros)
                OS="arch"
                PKG_MANAGER="pacman"
                ;;
            fedora|rhel|centos)
                OS="fedora"
                PKG_MANAGER="dnf"
                ;;
            *)
                log_error "Unsupported distribution: $ID"
                exit 1
                ;;
        esac
    else
        log_error "Cannot detect OS"
        exit 1
    fi
    log_info "Detected OS: $OS (using $PKG_MANAGER)"
}

# Install Homebrew (macOS)
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to path for current session
        if [[ "$OSTYPE" == "darwin"* ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log_success "Homebrew already installed"
    fi
}

# Install packages based on OS
install_packages() {
    log_info "Installing packages..."

    # Core packages (names vary by OS)
    case "$PKG_MANAGER" in
        brew)
            brew install \
                zsh \
                neovim \
                tmux \
                starship \
                eza \
                bat \
                fzf \
                zoxide \
                ripgrep \
                fd \
                git-delta \
                lazygit \
                jq \
                htop \
                ghostty
            ;;
        apt)
            sudo apt update
            sudo apt install -y \
                zsh \
                neovim \
                tmux \
                fzf \
                ripgrep \
                fd-find \
                jq \
                htop \
                curl \
                git \
                unzip

            # Install tools not in apt repos
            install_from_cargo_or_binary
            ;;
        pacman)
            sudo pacman -Syu --noconfirm \
                zsh \
                neovim \
                tmux \
                starship \
                eza \
                bat \
                fzf \
                zoxide \
                ripgrep \
                fd \
                git-delta \
                lazygit \
                jq \
                htop

            # Ghostty from AUR
            if command -v yay &> /dev/null; then
                yay -S --noconfirm ghostty
            elif command -v paru &> /dev/null; then
                paru -S --noconfirm ghostty
            else
                log_warn "Install ghostty manually from AUR"
            fi
            ;;
        dnf)
            sudo dnf install -y \
                zsh \
                neovim \
                tmux \
                fzf \
                ripgrep \
                fd-find \
                jq \
                htop \
                curl \
                git \
                unzip

            # Install tools not in dnf repos
            install_from_cargo_or_binary
            ;;
    esac

    log_success "Packages installed"
}

# Install tools from cargo or binaries (for apt/dnf)
install_from_cargo_or_binary() {
    log_info "Installing additional tools..."

    # Starship
    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Eza
    if ! command -v eza &> /dev/null; then
        if [[ "$PKG_MANAGER" == "apt" ]]; then
            sudo mkdir -p /etc/apt/keyrings
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
            sudo apt update
            sudo apt install -y eza
        else
            cargo install eza 2>/dev/null || log_warn "Install eza manually"
        fi
    fi

    # Bat (might be called batcat on Ubuntu)
    if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
        sudo apt install -y bat 2>/dev/null || sudo dnf install -y bat 2>/dev/null || true
    fi

    # Create symlink for batcat -> bat on Ubuntu
    if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -sf $(which batcat) ~/.local/bin/bat
    fi

    # fd symlink on Ubuntu (fd-find -> fd)
    if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -sf $(which fdfind) ~/.local/bin/fd
    fi

    # Zoxide
    if ! command -v zoxide &> /dev/null; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    # Delta
    if ! command -v delta &> /dev/null; then
        DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq -r .tag_name)
        if [[ "$PKG_MANAGER" == "apt" ]]; then
            wget -qO /tmp/delta.deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
            sudo dpkg -i /tmp/delta.deb
        elif [[ "$PKG_MANAGER" == "dnf" ]]; then
            sudo dnf install -y "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta-${DELTA_VERSION}-1.x86_64.rpm"
        fi
    fi

    # Lazygit
    if ! command -v lazygit &> /dev/null; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | jq -r '.tag_name' | sed 's/v//')
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
        sudo install /tmp/lazygit /usr/local/bin
    fi

    # Ghostty (build from source or download)
    if ! command -v ghostty &> /dev/null; then
        log_warn "Ghostty needs manual installation: https://ghostty.org/download"
    fi
}

# Install fonts
install_fonts() {
    log_info "Installing JetBrains Mono Nerd Font..."

    FONT_DIR=""
    if [[ "$OS" == "macos" ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
    fi

    mkdir -p "$FONT_DIR"

    if [[ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]]; then
        curl -Lo /tmp/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        unzip -o /tmp/JetBrainsMono.zip -d "$FONT_DIR"

        # Refresh font cache on Linux
        if [[ "$OS" != "macos" ]]; then
            fc-cache -fv
        fi

        log_success "Fonts installed"
    else
        log_success "Fonts already installed"
    fi
}

# Clone dotfiles
setup_dotfiles() {
    log_info "Setting up dotfiles..."

    DOTFILES_REPO="https://github.com/robert-cronin/.dotfiles.git"

    # Backup existing dotfiles directory
    if [[ -d "$HOME/.dotfiles" ]]; then
        log_warn "Backing up existing .dotfiles to .dotfiles.bak"
        mv "$HOME/.dotfiles" "$HOME/.dotfiles.bak.$(date +%s)"
    fi

    # Clone as bare repo
    git clone --bare "$DOTFILES_REPO" "$HOME/.dotfiles"

    # Define dotfiles alias for this script
    dotfiles() {
        git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
    }

    # Backup conflicting files
    mkdir -p "$HOME/.dotfiles-backup"
    dotfiles checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
        if [[ -f "$HOME/$file" ]]; then
            mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
            mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
            log_warn "Backed up: $file"
        fi
    done

    # Checkout dotfiles
    dotfiles checkout
    dotfiles config --local status.showUntrackedFiles no

    log_success "Dotfiles installed"
}

# Install Zinit
install_zinit() {
    log_info "Installing Zinit..."

    ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
    if [[ ! -d "$ZINIT_HOME" ]]; then
        mkdir -p "$(dirname "$ZINIT_HOME")"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        log_success "Zinit installed"
    else
        log_success "Zinit already installed"
    fi
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    log_info "Installing TPM..."

    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$TPM_DIR" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        log_success "TPM installed"
    else
        log_success "TPM already installed"
    fi
}

# Install bat themes
install_bat_themes() {
    log_info "Installing bat themes..."

    BAT_THEMES_DIR="$(bat --config-dir)/themes"
    mkdir -p "$BAT_THEMES_DIR"

    if [[ ! -f "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" ]]; then
        curl -Lo "$BAT_THEMES_DIR/Catppuccin Mocha.tmTheme" \
            "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme"
        bat cache --build
        log_success "Bat themes installed"
    else
        log_success "Bat themes already installed"
    fi
}

# Set default shell
set_default_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting zsh as default shell..."
        ZSH_PATH=$(which zsh)

        # Add to /etc/shells if not present
        if ! grep -q "$ZSH_PATH" /etc/shells; then
            echo "$ZSH_PATH" | sudo tee -a /etc/shells
        fi

        chsh -s "$ZSH_PATH"
        log_success "Default shell changed to zsh"
    else
        log_success "Zsh is already default shell"
    fi
}

# Main installation
main() {
    echo ""
    log_info "Starting installation..."
    echo ""

    detect_os

    if [[ "$OS" == "macos" ]]; then
        install_homebrew
    fi

    install_packages
    install_fonts
    setup_dotfiles
    install_zinit
    install_tpm
    install_bat_themes
    set_default_shell

    echo ""
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  Installation complete!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo ""
    echo -e "Next steps:"
    echo -e "  1. ${CYAN}Restart your terminal${NC} or run: ${YELLOW}exec zsh${NC}"
    echo -e "  2. Open ${CYAN}tmux${NC} and press ${YELLOW}prefix + I${NC} to install plugins"
    echo -e "  3. Open ${CYAN}nvim${NC} - LazyVim will auto-install plugins"
    echo ""
    echo -e "${PURPLE}Enjoy your new setup!${NC}"
}

# Run
main "$@"
