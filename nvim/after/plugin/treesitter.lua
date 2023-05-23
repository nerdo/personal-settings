local present, configs = pcall(require, "nvim-treesitter.configs")

if not present or vim.g.vscode then
	return
end

configs.setup({
	-- A list of parser names, or "all"
	ensure_installed = {
		"javascript",
		"typescript",
		"go",
		"json",
		"css",
		"yaml",
		"c",
		"lua",
		"rust",
		"markdown",
		"markdown_inline",
	},
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,
	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,
	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		-- `false` will disable the whole extension
		enable = true,
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})

-- Use Treesitter for code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Workaround for issue opening files with Telescope.
-- https://github.com/nvim-telescope/telescope.nvim/issues/699#issuecomment-1448928969
-- zx updates folds, zR expands all folds so the file looks "normal" when opened.
local telescope_is_present = pcall(require, "telescope")
if telescope_is_present then
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		pattern = { "*" },
		command = "normal zx zR",
	})
end
