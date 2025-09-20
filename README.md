# Minimal Dotfiles

A simple and intentional macOS development setup focused on essential tools and consistent theming.

## What's Included

### Essential CLI Tools
- **Micro** - Simple terminal text editor
- **btop** - System monitor with Tokyo Night theme
- **Fastfetch** - Beautiful system information display
- **Zoxide** - Smart directory navigation (`z` command)
- **Git** - Version control
- **Go** - Programming language
- **OpenCode** - AI-powered coding assistant

### Applications
- **Zen Browser** - Privacy-focused web browser
- **Visual Studio Code** - Code editor
- **Alt-Tab** - Improved window switcher for macOS
- **Raycast** - Productivity and launcher app
- **Ghostty** - Fast terminal emulator with Tokyo Night theme

### Theme
- Consistent **Tokyo Night** theme across all configured applications

## Installation

### Quick Setup (One-liner)
```bash
git clone https://github.com/katistix/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./setup.sh
```

### Manual Setup
```bash
# Clone the repository
git clone https://github.com/katistix/dotfiles.git ~/dotfiles

# Navigate to dotfiles directory and run setup
cd ~/dotfiles && ./setup.sh
```

The setup script will automatically:
- Install Homebrew (if not already installed)
- Install all CLI tools via `brew install`
- Install GUI applications via `brew install --cask`
- Install Oh My Zsh for improved shell experience
- Create symlinks using stow
- Backup existing configurations

## Configuration Details

### Terminal (Ghostty)
- Tokyo Night theme
- CartographCF Nerd Font
- Optimized for fullscreen use
- Cursor blinking enabled

### Shell Aliases
- `vim` → `micro` (simple text editor)
- `cat` → `micro -readonly` (read-only file viewing)

### Development
- Go workspace properly configured
- OpenCode CLI available in PATH
- Git integration with Oh My Zsh

## Philosophy

This setup prioritizes:
- **Simplicity** - Only essential tools, no bloat
- **Consistency** - Tokyo Night theme everywhere possible
- **Intentionality** - Each tool serves a specific purpose
- **Performance** - Fast, lightweight applications