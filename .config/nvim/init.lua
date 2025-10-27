-- ============================================================================
-- NEOVIM CONFIGURATION
-- A minimal, Go-focused setup with Telescope, LSP, and completion
-- ============================================================================

-- ============================================================================
-- LEADER KEY SETUP
-- Set leader keys before any plugin configurations
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- BASIC EDITOR SETTINGS
-- Core Neovim options for a better editing experience
-- ============================================================================

-- Line numbers and display
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.cursorline = true       -- Highlight current line
vim.opt.scrolloff = 10          -- Keep 10 lines above/below cursor

-- Mouse and clipboard
vim.opt.mouse = "a"             -- Enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- Search and matching
vim.opt.ignorecase = true       -- Ignore case in search
vim.opt.smartcase = true        -- Case-sensitive if uppercase used
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.inccommand = "split"    -- Show substitution preview

-- Indentation and formatting
vim.opt.breakindent = true      -- Maintain indent on wrapped lines
vim.opt.smartindent = true      -- Smart autoindenting
vim.opt.tabstop = 2             -- Tab width
vim.opt.shiftwidth = 2          -- Indent width
vim.opt.expandtab = true        -- Use spaces instead of tabs

-- File and backup settings
vim.opt.undofile = true         -- Persistent undo

-- Interface
vim.opt.showmode = false        -- Hide mode in command line (shown in statusline)       
vim.opt.splitright = true       -- Vertical splits go to the right
vim.opt.splitbelow = true       -- Horizontal splits go below
vim.opt.list = true             -- Show invisible characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Performance
vim.opt.updatetime = 250        -- Faster completion
vim.opt.timeoutlen = 300        -- Faster key sequences

-- ============================================================================
-- KEY MAPPINGS
-- Essential keybindings (most LSP bindings use defaults)
-- ============================================================================

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ============================================================================
-- AUTOCOMMANDS
-- Automatic behaviors for better workflow
-- ============================================================================

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Go-specific settings (tabs instead of spaces, proper width)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },
  group = vim.api.nvim_create_augroup("go-settings", { clear = true }),
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false  -- Go uses real tabs
  end,
})

-- ============================================================================
-- PLUGIN MANAGER (LAZY.NVIM) SETUP
-- Bootstrap and configure the plugin manager
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGIN CONFIGURATION
-- All plugins configured in a single place
-- ============================================================================

require("lazy").setup({
  -- ==========================================================================
  -- COLORSCHEME
  -- ==========================================================================
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("moonfly")
    end,
  },

  -- ==========================================================================
  -- SYNTAX HIGHLIGHTING (TREESITTER)
  -- ==========================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      -- Install parsers for Go and essential languages
      ensure_installed = { "go", "lua", "vim", "vimdoc", "markdown", "bash" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- ==========================================================================
  -- FUZZY FINDER (TELESCOPE)
  -- ==========================================================================
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Fast fuzzy finding algorithm
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      require("telescope").setup({})
      
      -- Load fuzzy finder extension
      pcall(require("telescope").load_extension, "fzf")

      -- Simple telescope keybindings
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", function() builtin.find_files({hidden=true, file_ignore_patterns={".git/"}}) end, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end,
  },

  -- ==========================================================================
  -- AUTOCOMPLETION
  -- ==========================================================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP completions
      "hrsh7th/cmp-buffer",      -- Buffer text completions
      "hrsh7th/cmp-path",        -- File path completions
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Accept completion with Enter
          ["<C-Space>"] = cmp.mapping.complete(),             -- Trigger completion
          ["<C-e>"] = cmp.mapping.abort(),                    -- Cancel completion
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },  -- LSP completions (primary)
          { name = "buffer" },    -- Text from current buffer
          { name = "path" },      -- File paths
        }),
      })
    end,
  },

  -- ==========================================================================
  -- AUTOPAIRS
  -- Auto-close brackets, quotes, parentheses, etc.
  -- ==========================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,  -- Use treesitter for better pair detection
        ts_config = {
          lua = { "string" },  -- Don't autopair in lua strings
          javascript = { "template_string" },
          java = false,  -- Don't use treesitter for java
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = "<M-e>",  -- Alt+e for fast wrap
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment"
        },
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- ==========================================================================
  -- FILE EXPLORER (NVIM-TREE)
  -- VSCode-like file tree explorer
  -- ==========================================================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        filters = {
          dotfiles = false,
          custom = { ".git", "node_modules", ".cache" },
        },
        git = {
          enable = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = true,
            },
          },
        },
      })

      -- Toggle nvim-tree with leader+e (similar to VSCode Ctrl+Shift+E)
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>E", ":NvimTreeFindFile<CR>", { desc = "Find file in explorer" })
    end,
  },

  -- ==========================================================================
  -- TERMINAL TOGGLE
  -- VSCode-like integrated terminal toggle
  -- ==========================================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],  -- Ctrl+\ to toggle (same as VSCode)
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,    -- Apply mappings in insert mode
        terminal_mappings = true,  -- Apply mappings in terminal mode
        persist_size = true,
        direction = "horizontal",  -- Open terminal at bottom like VSCode
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      })

      -- Key mappings for terminal toggle
      vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
      vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "Toggle terminal from terminal mode" })
      
      -- Navigate between terminal and other windows
      vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
      vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window" })
      vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window" })
      vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })
    end,
  },

  -- ==========================================================================
  -- LSP CONFIGURATION
  -- Language Server Protocol for Go and Lua
  -- ==========================================================================
  
  -- LSP manager (installs language servers)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Bridge between Mason and LSP config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- Automatically install these language servers
        ensure_installed = { "gopls", "lua_ls" },
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      -- Get completion capabilities from nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Configure Go language server (gopls) using new vim.lsp.config API
      vim.lsp.config.gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.mod', '.git' },
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,              -- Use gofumpt for formatting
            analyses = {
              unusedparams = true,       -- Detect unused parameters
              unusedwrite = true,        -- Detect unused writes
            },
            staticcheck = true,          -- Enable static analysis
          },
        },
      }

      -- Configure Lua language server using new vim.lsp.config API
      vim.lsp.config.lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },       -- Recognize 'vim' as global
            },
          },
        },
      }

      -- Enable the configured language servers
      vim.lsp.enable({ 'gopls', 'lua_ls' })

      -- Auto-format and organize imports on save for Go files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          -- Format the file
          vim.lsp.buf.format()
          
          -- Organize imports
          local params = vim.lsp.util.make_range_params(nil, "utf-16")
          params.context = {only = {"source.organizeImports"}}
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
        end
      })
    end,
  },
})

-- ============================================================================
-- DIAGNOSTICS BOX TOGGLE
-- Simple diagnostics display with toggle functionality
-- ============================================================================

local diagnostics_win = nil
local diagnostics_buf = nil

local function toggle_diagnostics_box()
  if diagnostics_win and vim.api.nvim_win_is_valid(diagnostics_win) then
    vim.api.nvim_win_close(diagnostics_win, true)
    diagnostics_win = nil
    diagnostics_buf = nil
  else
    local diagnostics = vim.diagnostic.get()
    
    if #diagnostics == 0 then
      vim.notify("No diagnostics found", vim.log.levels.INFO)
      return
    end

    local lines = {}
    local highlights = {}
    
    for _, diag in ipairs(diagnostics) do
      local severity = vim.diagnostic.severity[diag.severity]
      local icon = severity == "ERROR" and "✗" or severity == "WARN" and "⚠" or severity == "INFO" and "ℹ" or "󰌶"
      local line = string.format("%s %s:%d:%d - %s", icon, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(diag.bufnr), ":t"), diag.lnum + 1, diag.col + 1, diag.message)
      table.insert(lines, line)
      
      local hl_group = "DiagnosticSign" .. severity:sub(1,1) .. severity:sub(2):lower()
      table.insert(highlights, { line_nr = #lines - 1, hl_group = hl_group })
    end
    
    diagnostics_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(diagnostics_buf, 0, -1, false, lines)
    vim.bo[diagnostics_buf].modifiable = false
    vim.bo[diagnostics_buf].buftype = "nofile"
    
    local width = math.min(vim.o.columns - 4, 80)
    local height = math.min(#lines, 15)
    
    diagnostics_win = vim.api.nvim_open_win(diagnostics_buf, false, {
      relative = "editor",
      width = width,
      height = height,
      row = 2,
      col = 2,
      style = "minimal",
      border = "rounded",
      title = " Diagnostics ",
      title_pos = "center"
    })
    
    for _, hl in ipairs(highlights) do
      vim.api.nvim_buf_add_highlight(diagnostics_buf, -1, hl.hl_group, hl.line_nr, 0, -1)
    end
    
    vim.api.nvim_buf_set_keymap(diagnostics_buf, "n", "q", ":lua vim.api.nvim_win_close(" .. diagnostics_win .. ", true); diagnostics_win = nil; diagnostics_buf = nil<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(diagnostics_buf, "n", "<Esc>", ":lua vim.api.nvim_win_close(" .. diagnostics_win .. ", true); diagnostics_win = nil; diagnostics_buf = nil<CR>", { noremap = true, silent = true })
  end
end

vim.keymap.set("n", "<leader>d", toggle_diagnostics_box, { desc = "Toggle diagnostics box" })

-- ============================================================================
-- DEFAULT LSP KEYBINDINGS
-- Neovim 0.10+ provides these built-in LSP keybindings:
-- 
-- gd          - Go to definition
-- gr          - Go to references  
-- gD          - Go to declaration
-- gI          - Go to implementation
-- K           - Show hover documentation
-- <C-]>       - Go to definition (alternative)
-- <C-W>d      - Open definition in new window
-- <C-W><C-]>  - Open definition in new window (alternative)
-- 
-- Diagnostic navigation:
-- ]d          - Next diagnostic
-- [d          - Previous diagnostic
-- <C-W>d      - Open diagnostic float
-- 
-- You can add custom keybindings here if needed, but the defaults cover
-- most common LSP operations.
-- ============================================================================
