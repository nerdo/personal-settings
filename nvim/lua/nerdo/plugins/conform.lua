-- Case-intelligent serach and replace.
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local prettier = { "prettierd", "prettier" }
		local webdev = { prettier, "rustywind" }

		-- Modify phpcbf to set the php.ini display_errors value to off.
		-- Without it I was getting some warnings/errors that were polluting my code on format.
		conform.formatters.phpcbf.args = function(ctx)
			return { "-d", "display_errors", "off", "-q", "--stdin-path=" .. ctx.filename, "-" }
		end

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
				php = { "phpcbf" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 500,
			},
		})
	end,
}
