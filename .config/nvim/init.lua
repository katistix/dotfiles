require("config.lazy")

vim.opt.expandtab = true -- Use spaces instead of actual tabs
vim.opt.tabstop = 2 -- How wide a tab looks
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.softtabstop = 0 -- Let tabstop handle it
vim.opt.smartindent = true -- Basic smart indenting

vim.opt.number = true -- Show the line number for the current line
vim.opt.relativenumber = true -- Show relative numbers for all other lines

vim.opt.clipboard = "unnamedplus"

require("config.mappings")

vim.cmd("colorscheme onedark")
