return {
  "echasnovski/mini.nvim",
  config = function()
    local statusline = require("mini.statusline")
    statusline.setup({ use_icons = vim.g.have_nerd_font })

    local comment = require("mini.comment")
    comment.setup()

    local pairs = require("mini.pairs")
    pairs.setup()

    local surround = require("mini.surround")
    surround.setup()
  end,
}