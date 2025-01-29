-- Case-intelligent serach and replace.
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local prettier = { "prettierd" }
		local webdev = { "prettierd", "rustywind", stop_after_first = false }

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = webdev,
				typescript = webdev,
				javascriptreact = webdev,
				typescriptreact = webdev,
				html = webdev,
				css = prettier,
				json = prettier,
				yaml = prettier,
				markdown = prettier,
				ruby = { "robocup" },
				rust = { "rustfmt" },
				php = { "phpcbf" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 500,
			},
		})
	end,
}
