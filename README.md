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

### Theme
- Consistent **Tokyo Night** theme across all applications

## Installation

### Requirements
```bash
# Install dependencies via Homebrew
brew install git stow neovim ghostty zellij aerospace btop zoxide
```

### Setup
```bash
# Clone the repository
git clone https://github.com/katistix/dotfiles.git ~/dotfiles/

# Navigate to dotfiles directory
cd ~/dotfiles

# Create symlinks using stow
stow .
```

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
