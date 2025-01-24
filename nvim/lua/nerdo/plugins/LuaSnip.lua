if vim.g.nerdo_is_headless then
	return {}
end

return {
	"L3MON4D3/LuaSnip",
	config = function()
		local luasnip = require("luasnip")

		vim.keymap.set("i", "<Right>", function()
			luasnip.jump(1)
		end, { noremap = true, silent = true })
		vim.keymap.set("s", "<Right>", function()
			luasnip.jump(1)
		end, { noremap = true, silent = true })
		vim.keymap.set("i", "<Left>", function()
			luasnip.jump(-1)
		end, { noremap = true, silent = true })
		vim.keymap.set("s", "<Left>", function()
			luasnip.jump(-1)
		end, { noremap = true, silent = true })
	end,
}
