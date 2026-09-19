#!/bin/bash

ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# neovim
mkdir -p ~/.config/nvim
ln -sf ~/dotfiels/.config/nvim/init.lua ~/.config/nvim/init.lua

echo "Dotfiles installed successfully!"
