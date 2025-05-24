-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

return {
  -- Navigate between tmux and vim splits
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.api.nvim_set_keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { noremap = true, silent = true })
    end,
  },
}
