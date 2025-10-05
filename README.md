# Minimal Dotfiles

A simple and intentional macOS development setup focused on essential tools and consistent theming.

## What's Included

### Essential CLI Tools
- **Neovim** - Modern terminal text editor with LSP, autocompletion, and fuzzy finding
- **btop** - System monitor with Moonfly theme
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
- **Ghostty** - Fast terminal emulator with Moonfly theme

### Theme
- Consistent **Moonfly** theme across all configured applications

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
- Moonfly theme
- CartographCF Nerd Font
- Optimized for fullscreen use
- Cursor blinking enabled

### Neovim
- **LSP Support**: Auto-installed language servers for multiple languages
- **Autocompletion**: Smart completion with nvim-cmp
- **Fuzzy Finding**: Telescope for files and content search
- **Syntax Highlighting**: Treesitter with essential parsers
- **Theme**: Moonfly colorscheme matching terminal
- **Key Hints**: Which-key for discovering shortcuts

#### Key Bindings
- `<Space>` - Leader key
- `<Space>sf` - Find files
- `<Space>sg` - Search git files (including hidden)
- `<Space>sl` - Live grep search
- `<Space><Space>` - Switch buffers
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show documentation

### Shell Aliases
- `vim` → `nvim` (modern Neovim editor)
- `vi` → `nvim` (modern Neovim editor)

### Development
- Go workspace properly configured
- OpenCode CLI available in PATH
- Git integration with Oh My Zsh
- Mason auto-installs language servers

## Philosophy

This setup prioritizes:
- **Simplicity** - Only essential tools, no bloat
- **Consistency** - Moonfly theme everywhere possible
- **Intentionality** - Each tool serves a specific purpose
- **Performance** - Fast, lightweight applications
- **Modern Development** - LSP, autocompletion, and fuzzy finding built-in