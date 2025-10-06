return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    local Terminal = require('toggleterm.terminal').Terminal
    
    local make_build = Terminal:new({
      cmd = "make",
      dir = "git_dir",
      direction = "horizontal",
      close_on_exit = false,
    })
    
    local make_clean = Terminal:new({
      cmd = "make clean",
      dir = "git_dir", 
      direction = "horizontal",
      close_on_exit = false,
    })

    local gcc_build = Terminal:new({
      cmd = function()
        local file = vim.fn.expand("%:t:r")
        return "gcc -g -Wall -Wextra -std=c99 " .. vim.fn.expand("%") .. " -o " .. file
      end,
      dir = vim.fn.expand("%:p:h"),
      direction = "horizontal",
      close_on_exit = false,
    })

    function _MAKE_BUILD_TOGGLE()
      make_build:toggle()
    end

    function _MAKE_CLEAN_TOGGLE()
      make_clean:toggle()
    end

    function _GCC_BUILD_TOGGLE()
      gcc_build:toggle()
    end

    vim.api.nvim_set_keymap("n", "<leader>mb", "<cmd>lua _MAKE_BUILD_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Make build"})
    vim.api.nvim_set_keymap("n", "<leader>mc", "<cmd>lua _MAKE_CLEAN_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Make clean"})
    vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>lua _GCC_BUILD_TOGGLE()<CR>", {noremap = true, silent = true, desc = "GCC build current file"})
  end,
}