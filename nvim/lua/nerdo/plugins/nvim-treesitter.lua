return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})

		-- Install parsers if missing.
		local ensure_installed = {
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
		}
		local installed = require("nvim-treesitter.config").get_installed()
		local to_install = vim.iter(ensure_installed)
			:filter(function(parser)
				return not vim.tbl_contains(installed, parser)
			end)
			:totable()
		if #to_install > 0 then
			require("nvim-treesitter").install(to_install)
		end

		-- Enable highlighting and indentation via FileType autocmd.
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				-- Disable on large files.
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return
				end
				pcall(vim.treesitter.start)
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
