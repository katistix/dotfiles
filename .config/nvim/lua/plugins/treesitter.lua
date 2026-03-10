return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master", -- The master branch has the stable/legacy config structure
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {

			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css" },
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		},
	},
}
