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
brew install btop zoxide git go fastfetch opencode stow fzf || echo "Some packages may already be installed"
echo "Installing cask applications..."
brew install --cask zen-browser visual-studio-code alt-tab raycast ghostty kitty nikitabobko/tap/aerospace || echo "Some apps may already be installed"

# Install zathura from the correct tap
echo "Installing zathura..."
brew tap zathura-pdf-poppler/zathura-pdf-poppler || echo "Tap may already be added"
brew install zathura zathura-pdf-poppler || echo "Zathura may already be installed"

# Install Oh My Zsh if needed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &> /dev/null
fi

# Navigate to dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Create symlinks
echo "Creating symlinks..."
stow .

echo "✓ Setup complete"
echo "Run: source ~/.zshrc"