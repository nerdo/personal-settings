return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	-- enabled = function()
	-- 	return not vim.g.vscode
	-- end,
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- A list of parser names, or "all"
			ensure_installed = {
				"javascript",
				"typescript",
				"tsx",
				"bash",
				"dockerfile",
				"gitignore",
				"query",
				"go",
				"json",
				"http",
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

			-- better indentation with =
			indent = { enable = true },

			highlight = {
				-- `false` will disable the whole extension
				enable = true,

				-- Disable on large files.
				disable = function(_lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					local s = ""
					if ok and stats and stats.size then
						s = stats.size
					end

					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,

				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
