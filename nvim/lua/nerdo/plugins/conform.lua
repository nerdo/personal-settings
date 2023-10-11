-- Case-intelligent serach and replace.
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local prettier = { "prettierd", "prettier" }
		local webdev = { prettier, "rustywind" }
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = webdev,
				typescript = webdev,
				javascriptreact = webdev,
				typescriptreact = webdev,
				html = webdev,
				css = { prettier },
				json = { prettier },
				yaml = { prettier },
				markdown = { prettier },
				ruby = { "robocup" },
				rust = { "rustfmt" },
				php = { "php_cs_fixer" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 500,
			},
		})
	end,
}
