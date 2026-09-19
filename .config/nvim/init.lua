-- Set leader keys BEFORE loading lazy (Space is the standard default)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
}
})
