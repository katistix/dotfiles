#!/bin/bash

set -e

echo "Setting up dotfiles..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: macOS required"
    exit 1
fi

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Install dependencies
echo "Installing packages..."
brew install micro btop zoxide git go fastfetch opencode stow &> /dev/null || echo "Some packages may already be installed"
brew install --cask zen-browser visual-studio-code alt-tab raycast ghostty zed&> /dev/null || echo "Some apps may already be installed"

# Install Oh My Zsh if needed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &> /dev/null
fi

# Navigate to dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Backup existing configs
[[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]] && mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
[[ -f "$HOME/.config/btop/btop.conf" && ! -L "$HOME/.config/btop/btop.conf" ]] && mv "$HOME/.config/btop/btop.conf" "$HOME/.config/btop/btop.conf.backup"
[[ -f "$HOME/.config/ghostty/config" && ! -L "$HOME/.config/ghostty/config" ]] && mv "$HOME/.config/ghostty/config" "$HOME/.config/ghostty/config.backup"

# Create symlinks
echo "Creating symlinks..."
stow .

echo "✓ Setup complete"
echo "Run: source ~/.zshrc"