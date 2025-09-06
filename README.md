# dotfiles

A simple and clean macOS development setup focused on terminal-based workflows.

## What's Included

### Terminal & Shell
- **Ghostty** - Fast terminal emulator with Tokyo Night theme
- **Zellij** - Terminal multiplexer with custom keybindings (auto-starts on shell launch)
- **Zsh** with Oh My Zsh and custom aliases
- **Zoxide** for smart directory navigation

### Development Tools
- **Neovim** - LazyVim configuration with minimal fallback
- **AeroSpace** - Tiling window manager (configured for floating windows by default)
- **btop** - System monitor with Tokyo Night theme
- **Typst** - Modern document preparation system

### Theme
- Consistent **Tokyo Night** theme across all applications

## Installation

### Quick Setup (One-liner)
```bash
curl -fsSL https://raw.githubusercontent.com/katistix/dotfiles/main/setup.sh | bash -s -- && cd ~/dotfiles && ./setup.sh
```

### Manual Setup
```bash
# Clone the repository
git clone https://github.com/katistix/dotfiles.git ~/dotfiles/

# Navigate to dotfiles directory and run setup
cd ~/dotfiles && ./setup.sh
```

The setup script will automatically:
- Install Homebrew (if not already installed)
- Install all required dependencies including **Typst**
- Install Oh My Zsh
- Create symlinks using stow
- Backup existing configurations

## Configuration Details

### Neovim
- Default: LazyVim configuration (`nvim-lazy/`)
- Alternative: Minimal setup (`nvim-minimal/`)
- Aliases: `nvim` (LazyVim), `nvimm` (minimal)

### Zellij
- Auto-starts in terminal sessions (except VSCode)
- Custom tmux-like keybindings
- Tokyo Night theme

### AeroSpace
- Floating windows by default
- Alt+1-5 for workspace switching
- Alt+Shift+1-5 for moving windows

### Shell Aliases
- `npm` → `pnpm`
- `nvim` → LazyVim configuration
- `nvimm` → Minimal Neovim setup
