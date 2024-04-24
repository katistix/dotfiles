#!/usr/bin/env bash

# Install command-line tools using Homebrew

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Update and upgrade already-installed formulae
brew update
brew upgrade


# Install binaries
brew install git
brew install wget
brew install stow
brew install tmux

# Install casks
brew install --cask alacritty --no-quarantine
brew install --cask rectangle

# Install fzf
brew install fzf
$(brew --prefix)/opt/fzf/install
