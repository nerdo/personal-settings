-- Theme.
return {
	"navarasu/onedark.nvim",
	lazy = false,
	config = function()
		local onedark = require("onedark")
		onedark.setup({
			style = "deep",
		})
		onedark.load()

		-- Set cusror line color.
		vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = "DarkBlue", bg = "#0d1017" })

		-- Set gutter line number colors.
		vim.api.nvim_set_hl(0, "LineNrAbove", { ctermfg = "red", fg = "#C46EA2" })
		vim.api.nvim_set_hl(0, "LineNrBelow", { ctermfg = "green", fg = "#6EC48B" })
		vim.api.nvim_set_hl(0, "LineNrAbsolute", { ctermfg = "gray", fg = "#444444" })
		vim.api.nvim_set_hl(
			0,
			"CursorLineNr",
			{ ctermfg = "yellow", fg = "yellow", ctermbg = "DarkBlue", bg = "#0841A1" }
		)
	end,
}
