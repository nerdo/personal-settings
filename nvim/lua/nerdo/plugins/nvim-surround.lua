-- Surround things easily.
return {
	"kylechui/nvim-surround",
	version = "*", -- * = stable, main = latest featres
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({})
	end
}
