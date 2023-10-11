-- Signature autocompletion.
return {
	"ray-x/lsp_signature.nvim",
	enabled = false,
	event = "VeryLazy",
	config = function()
		local sig = require("lsp_signature")

		sig.setup({
			hint_inline = function()
				return true
			end,
		})
	end,
}
