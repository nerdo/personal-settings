-- Code outline.
return {
	'stevearc/aerial.nvim',
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		require('aerial').setup({
			on_attach = function(bufnr)
				local telescope_exists, telescope = pcall(require, "telescope")

				-- Jump forwards/backwards with '{' and '}'
				-- vim.keymap.set('n', '<C-,>', '<cmd>AerialPrev<CR>', { buffer = bufnr })
				-- vim.keymap.set('n', '<C-.>', '<cmd>AerialNext<CR>', { buffer = bufnr })
				if telescope_exists then
					vim.keymap.set('n', '<leader>o', function()
						telescope.extensions.aerial.aerial()
					end, { buffer = bufnr })
				else
					vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>', { buffer = bufnr })
				end
			end
		})
	end
}
