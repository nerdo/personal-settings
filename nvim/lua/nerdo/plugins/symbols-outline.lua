-- Symbols outline.
return {
	"simrat39/symbols-outline.nvim",
	config = function()
		local symbols_outline = require("symbols-outline")

		symbols_outline.setup({
			auto_close = true,
			show_numbers = true,
			show_relative_numbers = true,
			keymaps = {
				hover_symbol = "K",
				toggle_preview = "P",
			},
		})

		vim.keymap.set("n", "<leader>o", ":SymbolsOutline<CR>", {})
	end
}
