# Minimal Dotfiles

A simple and intentional macOS development setup focused on essential tools and consistent theming.

## What's Included

### Essential CLI Tools
- **Neovim** - Modern terminal text editor with LSP, autocompletion, and fuzzy finding
- **btop** - System monitor with Moonfly and TokyoNight themes
- **Fastfetch** - Beautiful system information display
- **Zoxide** - Smart directory navigation (`z` command)
- **Git** - Version control with Oh My Zsh integration
- **Go** - Programming language
- **OpenCode** - AI-powered coding assistant
- **Stow** - Symlink management for dotfiles

### Applications
- **Zen Browser** - Privacy-focused web browser
- **Visual Studio Code** - Code editor
- **Alt-Tab** - Improved window switcher for macOS
- **Raycast** - Productivity and launcher app
- **Ghostty** - Fast terminal emulator with Moonfly theme
- **Kitty** - Alternative terminal emulator with Moonfly theme
- **AeroSpace** - Tiling window manager for macOS
- **Zathura** - Lightweight PDF viewer

### Window Management
- **AeroSpace** configuration for minimal tiling with workspace switching (Alt+1-4)
- Terminal and Zathura automatically assigned to workspace 2

### Themes
- Primary: **Moonfly** theme across terminal, editors, and system monitor
- Alternative: **TokyoNight** theme available for btop

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
- Install AeroSpace from nikitabobko/tap
- Install Zathura with PDF support from zathura-pdf-poppler tap
- Install Oh My Zsh for improved shell experience
- Create symlinks using GNU Stow
- Backup existing configurations

## Configuration Details

### Window Management (AeroSpace)
- Minimal tiling window manager configuration
- Workspace switching with Alt+1-4
- Move windows between workspaces with Alt+Shift+1-4
- Terminal applications and Zathura auto-assigned to workspace 2

### Terminal (Ghostty & Kitty)
- Primary: Ghostty with Moonfly theme
- Alternative: Kitty with Moonfly theme and CartographCF Nerd Font
- Both optimized for development work

### Neovim
- **LSP Support**: Auto-installed language servers via Mason
- **Autocompletion**: Smart completion with nvim-cmp
- **Fuzzy Finding**: Telescope for files and content search
- **Syntax Highlighting**: Treesitter with essential parsers
- **Debug Adapter Protocol**: DAP configuration for debugging
- **Theme**: Moonfly colorscheme matching terminal
- **Key Hints**: Which-key for discovering shortcuts
- **Terminal Integration**: Built-in terminal support

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
- Go workspace properly configured with GOPATH/bin in PATH
- OpenCode CLI available in PATH
- Git integration with Oh My Zsh
- Mason auto-installs language servers for Neovim
- Zathura for lightweight PDF viewing

### System Monitor
- **btop** with custom Moonfly and TokyoNight themes
- Performance monitoring with consistent visual styling

## Philosophy

This setup prioritizes:
- **Simplicity** - Only essential tools, no bloat
- **Consistency** - Moonfly theme everywhere possible with TokyoNight alternatives
- **Intentionality** - Each tool serves a specific purpose
- **Performance** - Fast, lightweight applications
- **Modern Development** - LSP, autocompletion, debugging, and fuzzy finding built-in
- **Workspace Organization** - Automated window management with AeroSpace