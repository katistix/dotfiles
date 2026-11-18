-- Secondary Neovim config, tuned for Python.
-- Launch with: pynvim   (alias for NVIM_APPNAME=nvim-python nvim)
-- Plugins and state live in ~/.local/{share,state}/nvim-python, separate from
-- the main config, so the two setups never interfere.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options -------------------------------------------------------------------

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.list = false
opt.colorcolumn = "88"

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.winborder = "rounded"

opt.splitright = true
opt.splitbelow = true
opt.laststatus = 3
opt.pumheight = 12

opt.updatetime = 250
opt.timeoutlen = 300
opt.confirm = true
opt.undofile = true
opt.swapfile = false

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.inccommand = "split"

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 4, prefix = "●" },
  float = { border = "rounded", source = true },
  jump = { float = true },
})

-- Keymaps -------------------------------------------------------------------

local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save buffer" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Run the current file with the project's virtualenv (if there is one).
local function find_python()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  local candidates = {
    ".venv/bin/python",
    ".venv/bin/python3",
    "venv/bin/python",
    "venv/bin/python3",
  }

  while dir do
    for _, rel in ipairs(candidates) do
      local path = dir .. "/" .. rel
      if vim.fn.executable(path) == 1 then
        return path
      end
    end
    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  local python = vim.fn.exepath("python3")
  return python ~= "" and python or "python3"
end

map("n", "<leader>rr", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end
  if vim.bo.modified then
    vim.cmd.write()
  end
  vim.cmd("botright 12split")
  vim.cmd("terminal " .. vim.fn.shellescape(find_python()) .. " " .. vim.fn.shellescape(file))
  vim.cmd.startinsert()
end, { desc = "Run Python file" })

map("n", "<leader>rf", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file to format", vim.log.levels.WARN)
    return
  end
  vim.cmd("botright 12split")
  vim.cmd("terminal " .. vim.fn.shellescape(find_python()) .. " -m ruff format " .. vim.fn.shellescape(file))
  vim.cmd.startinsert()
end, { desc = "Run ruff format in terminal" })

-- Plugins -------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },

  -- LSP (basedpyright for types, ruff for lint/imports)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("basedpyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "standard",
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })

      local servers = {
        basedpyright = "basedpyright-langserver",
        ruff = "ruff",
      }
      for name, exe in pairs(servers) do
        if vim.fn.executable(exe) == 1 then
          vim.lsp.enable(name)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local function bufmap(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          bufmap("gd", vim.lsp.buf.definition, "Go to definition")
          bufmap("gI", vim.lsp.buf.implementation, "Go to implementation")
          bufmap("gr", vim.lsp.buf.references, "Go to references")
          bufmap("K", vim.lsp.buf.hover, "Hover documentation")
          bufmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          bufmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
          bufmap("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
          bufmap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          bufmap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
        end,
      })
    end,
  },

  -- Tree-sitter highlighting and indentation
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local wanted = { "python", "lua", "markdown", "markdown_inline", "toml", "yaml", "json", "bash" }
      local installed = ts.get_installed()
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, wanted)
      if #missing > 0 then
        ts.install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if ok and (ev.match == "python" or ev.match == "lua") then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Format on save
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
  },

  -- Fuzzy finder (fzf binary is already installed)
  {
    "ibhagwan/fzf-lua",
    opts = {},
    keys = {
      { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
      { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Help tags" },
      { "<leader>fd", function() require("fzf-lua").diagnostics_document() end, desc = "Document diagnostics" },
      { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "Document symbols" },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
      },
    },
  },
}, {
  checker = { enabled = false },
  change_detection = { notify = false },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.colorcolumn = "88"
  end,
})
