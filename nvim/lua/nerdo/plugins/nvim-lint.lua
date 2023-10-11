-- Case-intelligent serach and replace.
return {
	"mfussenegger/nvim-lint",
	enabled = false,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { { "eslint_d", "eslint" } },
			typescript = { { "eslint_d", "eslint" } },
			javascriptreact = { { "eslint_d", "eslint" } },
			typescriptreact = { { "eslint_d", "eslint" } },
			php = { "php", "phpcs" },
			markdown = { "vale" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
