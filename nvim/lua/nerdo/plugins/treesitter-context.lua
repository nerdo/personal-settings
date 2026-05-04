-- Keeps parts of the code on screen for context.
return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesitter-context").setup({
			mode = "topline",
			max_lines = 0,
			trim_scope = "outer",
			min_window_height = 0,
		})
	end,
}
