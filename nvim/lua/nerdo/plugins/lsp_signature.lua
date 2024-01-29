-- Signature autocompletion.
return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	config = function()
		local sig = require("lsp_signature")

		sig.setup({
			hint_enable = false,
			hint_inline = function()
				return false
			end,
		})
	end,
}
