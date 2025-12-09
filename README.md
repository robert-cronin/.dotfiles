# Dotfiles

Modern, minimal, cross-platform terminal setup with Catppuccin Mocha theming.

![Catppuccin](https://img.shields.io/badge/Catppuccin-Mocha-cba6f7?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMDI0IiBoZWlnaHQ9IjEwMjQiPjxwYXRoIGZpbGw9IiNjYmE2ZjciIGQ9Ik0wIDBoMTAyNHYxMDI0SDB6Ii8+PC9zdmc+)

## What's Included

| Tool | Purpose |
|------|---------|
| **Ghostty** | Fast, native terminal emulator |
| **Zsh + Zinit** | Shell with lightning-fast plugins |
| **Starship** | Cross-shell prompt |
| **Neovim (LazyVim)** | Modern editor setup |
| **Tmux** | Terminal multiplexer |
| **eza** | Modern `ls` replacement |
| **bat** | Modern `cat` with syntax highlighting |
| **fzf** | Fuzzy finder |
| **zoxide** | Smart `cd` |
| **ripgrep** | Fast `grep` |
| **fd** | Fast `find` |
| **delta** | Beautiful git diffs |
| **lazygit** | Git TUI |

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/robert-cronin/.dotfiles/main/scripts/install.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/robert-cronin/.dotfiles.git ~/dotfiles-temp
chmod +x ~/dotfiles-temp/scripts/install.sh
~/dotfiles-temp/scripts/install.sh
```

## Supported Platforms

- Ubuntu / Debian
- Arch Linux
- Fedora
- macOS

## Key Bindings

### Shell

| Binding | Action |
|---------|--------|
| `Shift+Tab` | Accept autosuggestion |
| `↑/↓` | History search |
| `Ctrl+R` | FZF history |
| `Tab` | FZF completion |

### Tmux (prefix: `Ctrl+a`)

| Binding | Action |
|---------|--------|
| `\|` | Split vertical |
| `-` | Split horizontal |
| `h/j/k/l` | Navigate panes |
| `c` | New window |
| `r` | Reload config |

### Neovim

LazyVim defaults. Press `Space` for command menu.

## Aliases

```bash
# Modern CLI
ls    → eza with icons
cat   → bat with syntax highlighting
cd    → zoxide smart navigation
grep  → ripgrep
find  → fd

# Git
lg    → lazygit
gs    → git status
ga    → git add
gc    → git commit
gp    → git push

# Dotfiles
dot   → git for dotfiles
dotlg → lazygit for dotfiles
```

## Structure

```
~/.config/
├── ghostty/config      # Terminal
├── nvim/               # LazyVim
├── tmux/tmux.conf      # Tmux
├── starship.toml       # Prompt
├── bat/config          # bat theme
└── lazygit/config.yml  # lazygit theme

~/.zshrc                # Shell config
~/.gitconfig            # Git + delta
```

## Post-Install

1. Restart terminal or run `exec zsh`
2. In tmux: `prefix + I` to install plugins
3. In nvim: plugins auto-install on first launch

## Credits

- [Catppuccin](https://github.com/catppuccin) - Color scheme
- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim distribution
- [Starship](https://starship.rs) - Prompt
- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager
