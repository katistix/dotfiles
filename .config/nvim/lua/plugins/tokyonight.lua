return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- This is the magic part
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})

			-- Load the colorscheme AFTER the setup
			-- vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
