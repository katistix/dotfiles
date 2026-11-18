#!/bin/bash

ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf


mkdir -p ~/.config/nvim

ln -sf ~/dotfiles/.config/ghostty/config ~/.config/ghostty/config
ln -sf ~/dotfiles/.config/nvim/init.lua ~/.config/nvim/init.lua
ln -sfn ~/dotfiles/.config/nvim-python ~/.config/nvim-python

# Tiling window manager (brew install --cask nikitabobko/tap/aerospace)
stow -d ~/dotfiles -t ~ aerospace

echo "Dotfiles installed successfully!"
