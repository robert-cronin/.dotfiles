# ~/.zshrc - Minimal, fast Zsh config with Zinit
# ================================================

# -----------------------------
# Homebrew
# -----------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# -----------------------------
# Zinit Installation
# -----------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# -----------------------------
# Plugins (lazy-loaded for speed)
# -----------------------------
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab

# -----------------------------
# Prompt: Starship
# -----------------------------
eval "$(starship init zsh)"

# -----------------------------
# Tool Integrations
# -----------------------------
# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# -----------------------------
# Aliases: Modern CLI Tools
# -----------------------------
# File listing (eza)
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza --tree --icons --level=2'
alias tree='eza --tree --icons'

# File viewing (bat)
alias cat='bat --paging=never'
alias less='bat'

# Navigation (zoxide)
alias cd='z'

# Search (ripgrep, fd)
alias grep='rg'
alias find='fd'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'
alias lg='lazygit'

# Dotfiles management (bare repo)
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias dots='dot status'
alias dota='dot add'
alias dotc='dot commit'
alias dotp='dot push'
alias dotl='dot pull'
alias dotlg='lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Quick edits
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias reload='source ~/.zshrc'

# System
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tmux
alias t='tmux'
alias ta='tmux attach'

# Directories
alias cdgh='cd $HOME/Documents/github'
alias tmp='cd $(mktemp -d)'

# -----------------------------
# History
# -----------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# -----------------------------
# Completion
# -----------------------------
autoload -Uz compinit
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'

# -----------------------------
# Key Bindings
# -----------------------------
bindkey -e  # Emacs mode
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[Z' autosuggest-accept  # shift + tab | autosuggest

# -----------------------------
# Environment
# -----------------------------
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# Go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -----------------------------
# Tool-specific completions
# -----------------------------
# kubectl (if installed)
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
    alias k='kubectl'
fi

# -----------------------------
# Local Overrides
# -----------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
