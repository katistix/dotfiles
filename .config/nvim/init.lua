-- Set leader keys BEFORE loading lazy (Space is the standard default)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options -------------------------------------------------------------------

local opt = vim.opt

opt.number = true
opt.relativenumber = true

-- Indentation: spaces, two per level (legacy `tabstop=8` files still look sane
-- because tabs are never inserted).
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- Completion popup: highlight the first match without inserting it, so typing
-- keeps filtering freely and only <CR>/<Tab> commits a choice.
opt.completeopt = { "menu", "menuone", "noinsert", "popup", "fuzzy" }

-- 1. Define the path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 2. Clone the repository if it doesn't exist on your machine yet
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

-- 3. Add lazy.nvim to Neovim's runtime path
vim.opt.rtp:prepend(lazypath)

-- 4. Initialize lazy with an empty plugin list
require("lazy").setup({
  -- You will add your plugins here later, e.g.,
  -- "nvim-tree/nvim-tree.lua",
  {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
      },
    },
  },
})

-- Prolog ---------------------------------------------------------------------
-- Neovim ships Prolog syntax, indentation and ftplugin support, and detects
-- `.pl` files from their contents. The rest of this file adds the missing
-- pieces: common extensions, buffer options, a run/REPL workflow and the
-- SWI-Prolog language server (when its pack is installed).

vim.filetype.add({
  extension = {
    prolog = "prolog",
    plt = "prolog",
  },
})

local prolog_augroup = vim.api.nvim_create_augroup("user_prolog", { clear = true })

local function swipl_executable()
  local exe = vim.fn.exepath("swipl")
  return exe ~= "" and exe or nil
end

local function current_file()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer is not a file", vim.log.levels.WARN)
    return nil
  end
  if vim.bo.modified then
    vim.cmd.write()
  end
  return file
end

local function open_terminal(command)
  vim.cmd("botright 12split")
  vim.cmd("terminal " .. command)
  vim.cmd.startinsert()
end

-- Quote a string as a Prolog atom so it can be embedded in a -g goal.
local function prolog_quote(text)
  local escaped = text:gsub("\\", "\\\\"):gsub("'", "\\'"):gsub("\n", "\\n")
  return "'" .. escaped .. "'"
end

-- SWI-Prolog language server: https://github.com/jamesnvc/lsp_server
-- Install with: swipl pack install lsp_server
vim.lsp.config("prolog_ls", {
  cmd = {
    "swipl",
    "-g", "use_module(library(lsp_server))",
    "-g", "lsp_server:main",
    "-t", "halt",
    "--", "stdio",
  },
  filetypes = { "prolog" },
  root_markers = { "pack.pl", ".git" },
})

local prolog_ls_checked = false

local function enable_prolog_lsp()
  if prolog_ls_checked then
    return
  end
  prolog_ls_checked = true

  if not swipl_executable() then
    return
  end

  local result = vim.system(
    { "swipl", "-q", "-g", "use_module(library(lsp_server))", "-t", "halt" },
    { text = true }
  ):wait()

  if result.code == 0 then
    vim.lsp.enable("prolog_ls")
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = prolog_augroup,
  pattern = "prolog",
  callback = function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.wrap = false

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map("<leader>rr", function()
      local file = current_file()
      if not file then
        return
      end
      open_terminal(vim.fn.shellescape(swipl_executable() or "swipl") .. " " .. vim.fn.shellescape(file))
    end, "Consult file in SWI-Prolog")

    map("<leader>rs", function()
      open_terminal(vim.fn.shellescape(swipl_executable() or "swipl"))
    end, "Start SWI-Prolog REPL")

    map("<leader>rq", function()
      local file = current_file()
      if not file then
        return
      end
      vim.ui.input({ prompt = "?- " }, function(goal)
        if not goal or goal == "" then
          return
        end
        goal = goal:gsub("%.%s*$", "")
        local exe = vim.fn.shellescape(swipl_executable() or "swipl")
        local code = string.format(
          "consult(%s), read_term_from_atom(%s, Goal, [variable_names(Names)]), findall(Names, call(Goal), Solutions), write(Solutions), nl",
          prolog_quote(file),
          prolog_quote(goal)
        )
        open_terminal(exe .. " -q -g " .. vim.fn.shellescape(code) .. " -t halt")
      end)
    end, "Run Prolog query against file")

    map("<leader>cf", function()
      local clients = vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/formatting" })
      if #clients == 0 then
        vim.notify("Prolog formatter unavailable: swipl pack install lsp_server", vim.log.levels.WARN)
        return
      end
      vim.lsp.buf.format({ bufnr = ev.buf, async = true })
    end, "Format Prolog buffer")

    enable_prolog_lsp()
  end,
})

-- C / C++ --------------------------------------------------------------------
-- clangd ships with the Xcode command line tools on macOS and implements
-- textDocument/formatting using clang-format internally, so no extra binary or
-- plugin is needed. `--fallback-style=LLVM` matches the two-space indent used
-- globally above when a project has no .clang-format file.

vim.lsp.config("clangd", {
  cmd = { "clangd", "--fallback-style=LLVM" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    ".clang-format",
    ".git",
  },
})

vim.lsp.enable("clangd")

local c_augroup = vim.api.nvim_create_augroup("user_c", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = c_augroup,
  pattern = { "c", "cpp" },
  callback = function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2

    vim.keymap.set("n", "<leader>cf", function()
      local clients = vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/formatting" })
      if #clients == 0 then
        vim.notify("C formatter unavailable: install the Xcode command line tools (clangd)", vim.log.levels.WARN)
        return
      end
      vim.lsp.buf.format({ bufnr = ev.buf, async = true })
    end, { buffer = ev.buf, desc = "Format C buffer" })
  end,
})

-- HTML / CSS / JavaScript ------------------------------------------------------
-- Vanilla HTML5, CSS and JS. Neovim already treats `.html` as HTML5 and
-- detects CSS/JS filetypes, so this section only adds the language servers,
-- Emmet abbreviations and Prettier formatting.
--
-- Servers come from npm (see README):
--   npm install -g vscode-langservers-extracted typescript@5 typescript-language-server @olrtg/emmet-language-server prettier

vim.filetype.add({
  extension = {
    htm = "html",
    xhtml = "html",
  },
})

vim.lsp.config("html", {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { ".git", "package.json" },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
  },
})

vim.lsp.config("cssls", {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { ".git", "package.json" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = false },
  },
})

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git", "package.json" },
  init_options = { provideFormatter = true },
})

-- typescript-language-server does not bundle tsserver, and the globally
-- installed `typescript` package is not in the project's node_modules, so point
-- it at the global tsserver when we can find one. Projects with their own
-- TypeScript installation keep using that instead.
local function global_tsserver_path()
  local exe = vim.fn.exepath("typescript-language-server")
  if exe == "" then
    return nil
  end
  -- <prefix>/lib/node_modules/typescript-language-server/lib/cli.mjs
  local node_modules = vim.fn.fnamemodify(vim.fn.resolve(exe), ":h:h:h")
  local tsserver = node_modules .. "/typescript/lib/tsserver.js"
  return vim.uv.fs_stat(tsserver) and tsserver or nil
end

local ts_init_options = {}
local tsserver_path = global_tsserver_path()
if tsserver_path then
  ts_init_options.tsserver = { path = tsserver_path }
end

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  init_options = ts_init_options,
})

-- Emmet turns `ul>li*3` into markup: type the abbreviation, then accept the
-- completion. Works in HTML, CSS/SCSS and JSX/TSX.
vim.lsp.config("emmet_language_server", {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" },
  root_markers = { ".git", "package.json" },
  init_options = {
    showExpandedAbbreviation = "always",
    showSuggestionsAsSnippets = true,
  },
})

-- Only enable servers whose binaries are on PATH; a missing one should not
-- produce errors every time a matching buffer is opened.
for name, exe in pairs({
  html = "vscode-html-language-server",
  cssls = "vscode-css-language-server",
  jsonls = "vscode-json-language-server",
  ts_ls = "typescript-language-server",
  emmet_language_server = "emmet-language-server",
}) do
  if vim.fn.exepath(exe) ~= "" then
    vim.lsp.enable(name)
  end
end

local web_augroup = vim.api.nvim_create_augroup("user_web", { clear = true })

local web_filetypes = {
  "html",
  "css",
  "scss",
  "less",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
}

vim.api.nvim_create_autocmd("FileType", {
  group = web_augroup,
  pattern = web_filetypes,
  callback = function(ev)
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map("<leader>cf", function()
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ async = true, lsp_format = "fallback" })
      else
        vim.lsp.buf.format({ bufnr = ev.buf, async = true })
      end
    end, "Format with Prettier")

    -- Open the current page in the default browser. Modules and fetch() need
    -- a real server, hence the separate serve command below.
    map("<leader>co", function()
      local file = vim.api.nvim_buf_get_name(0)
      if file == "" then
        vim.notify("Current buffer is not a file", vim.log.levels.WARN)
        return
      end
      if vim.bo.modified then
        vim.cmd.write()
      end
      vim.ui.open(file)
    end, "Open page in browser")

    map("<leader>cs", function()
      if vim.fn.exepath("python3") == "" then
        vim.notify("python3 is required to serve the site", vim.log.levels.WARN)
        return
      end
      local file = vim.api.nvim_buf_get_name(0)
      local dir = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
      local port = 8000
      open_terminal("cd " .. vim.fn.shellescape(dir) .. " && python3 -m http.server " .. port)
      vim.notify(string.format("Serving %s at http://localhost:%d", dir, port))
    end, "Serve current directory on :8000")
  end,
})

-- LSP keymaps and built-in completion for any attached server.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })

      -- <CR>/<Tab> accept the highlighted item; otherwise they behave normally.
      local function accept_or(key)
        return function()
          if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected ~= -1 then
            return "<C-y>"
          end
          return key
        end
      end
      vim.keymap.set("i", "<CR>", accept_or("<CR>"), { buffer = ev.buf, expr = true, desc = "Accept completion" })
      vim.keymap.set("i", "<Tab>", accept_or("<Tab>"), { buffer = ev.buf, expr = true, desc = "Accept completion" })
    end

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gI", vim.lsp.buf.implementation, "Go to implementation")
    map("gr", vim.lsp.buf.references, "Go to references")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
    map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
  end,
})
