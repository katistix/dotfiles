#!/bin/bash

set -e  # Exit on any error

echo "🚀 Setting up dotfiles..."

# Function to print status messages
print_status() {
    echo "📦 $1"
}

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This setup script is designed for macOS only."
    exit 1
fi

# Check if Homebrew is installed, install if not
if ! command -v brew &> /dev/null; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    print_status "Homebrew already installed ✅"
fi

# Install dependencies
print_status "Installing dependencies via Homebrew..."
brew install git stow neovim ghostty zellij btop zoxide typst

# Install Oh My Zsh if not already installed
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print_status "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_status "Oh My Zsh already installed ✅"
fi

# Navigate to dotfiles directory (we should already be here)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

print_status "Creating symlinks with stow..."

# Backup existing .zshrc if it exists and isn't a symlink
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    print_status "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Create symlinks using stow
stow .

print_status "Setup complete! 🎉"
echo ""
echo "📋 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. Launch any application to see the Tokyo Night theme"
echo ""
echo "🔧 Tools installed:"
echo "   • Ghostty (terminal)"
echo "   • Zellij (terminal multiplexer)"
echo "   • Neovim with LazyVim"
echo "   • btop (system monitor)"
echo "   • Zoxide (smart cd)"
echo "   • Typst (document preparation)"
echo ""
echo "💡 Use 'nvim' for LazyVim and 'nvimm' for minimal Neovim"
