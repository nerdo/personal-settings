return {
	-- Theme(s).
	{
		"kyoz/purify",
		lazy = false,
		priority = 1000,
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/vim")

			-- Override some colors for purify...
			-- Unfortunately, this seems to be the best place to put this so it doesn't get lost...
			vim.g.purify_override_colors = {
				yellow = { gui = "#f2f2e6", cterm = "Grey" },
			}

			-- Set the color scheme.
			vim.cmd.colorscheme("purify")
		end,
	},

	-- File explorer.
	{ "justinmk/vim-dirvish" },

	-- Automatic detection of tab size.
	{ "Darazaki/indent-o-matic" },

	-- Git info in file explorer.
	{ "kristijanhusak/vim-dirvish-git" },

	-- Replace UI for messages, cmdline, popupmenu.
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Abstract syntax tree that speeds up a lot of neovim operations.
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	-- Keeps parts of the code on screen for context.
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter" },
	},

	-- Better code folding.
	{ "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },

	-- Split/join lines.
	{
		"Wansmer/treesj",
		keys = { "<space>m", "<space>j", "<space>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Show symbols in gutter for git changes.
	{ "lewis6991/gitsigns.nvim" },

	-- Display tabs for buffers.
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},

	-- Status line.
	-- Note: for some reason this wipes out the NVIM splash screen buffer.
	{ "nvim-lualine/lualine.nvim", dependencies = "nvim-tree/nvim-web-devicons" },

	-- Terminal.
	{ "akinsho/toggleterm.nvim", version = "*" },

	-- Leap to specific positions in text.
	{ "ggandor/leap.nvim" },

	-- Show indent lines.
	{ "lukas-reineke/indent-blankline.nvim" },

	-- Automatically close html/jsx tags.
	{ "windwp/nvim-ts-autotag" },

	-- Comment out lines with keymap.
	{ "tpope/vim-commentary" },

	-- Surround things easily.
	{ "tpope/vim-surround" },

	-- Case-intelligent serach and replace.
	{ "tpope/vim-abolish" },

	-- Auto pairing of brackets and such.
	{ "windwp/nvim-autopairs" },

	-- JSON schema.
	{ "b0o/schemastore.nvim" },

	-- Symbols outline.
	{ "simrat39/symbols-outline.nvim" },

	-- Debug adapter.
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui", dependencies = "mfussenegger/nvim-dap" },

	-- LSP diagnostic info.
	{ "nerdo/trouble.nvim", dependencies = "nvim-tree/nvim-web-devicons" },

	-- LSPs
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",

			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",

			-- The rest are my own LSP requirements (NOT required for lsp-zero)

			-- for formatting code
			"jose-elias-alvarez/null-ls.nvim",

			-- Inlay hints for type/metadata.
			"lvimuser/lsp-inlayhints.nvim",

			-- Completion for neovim lua.
			"folke/neodev.nvim",
		},
	},

	-- Test runner.
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",

			-- Test adapters
			"rouge8/neotest-rust",
			"olimorris/neotest-phpunit",
			"marilari88/neotest-vitest",
			"haydenmeade/neotest-jest",
		},
	},
}
