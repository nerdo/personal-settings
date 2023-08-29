-- Leap to specific positions in text.
return {
	"ggandor/leap.nvim",
	config = function()
		local leap = require("leap")

		-- Leap caniballizes these two keymaps, which mess with standard vim behavior,
		-- but if we define a keymap, it won't overwrite it!
		vim.keymap.set({ "x", "o" }, "x", "x", { noremap = true })

		leap.add_default_mappings()
	end
}
