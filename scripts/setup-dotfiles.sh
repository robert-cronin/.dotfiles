#!/bin/bash

# Maximal laziness
# first do `git clone https://github.com/robert-cronin/.dotfiles.git`
# then `chmod +x setup-dotfiles.sh`
# then `./.dotfiles/scripts/setup-dotfiles.sh`

alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
mv $HOME/.dotfiles $HOME/.dotfiles.bak
git clone --bare https://github.com/robert-cronin/.dotfiles $HOME/.dotfiles

# Run `dotfiles reset --hard` to apply the changes (note to self: this will overwrite any existing overlapping files like .bashrc)
