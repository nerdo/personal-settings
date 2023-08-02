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

	-- Extend/create a/i textobjects.
	{ 'echasnovski/mini.nvim',  version = false },

	-- File explorer.
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Automatic detection of tab size.
	{ "Darazaki/indent-o-matic" },

	-- Replace UI for messages, cmdline, popupmenu.
	{
		"folke/noice.nvim",
		enabled = false,
		event = "VeryLazy",
		dependencies = "MunifTanjim/nui.nvim",
	},

	-- Perl compatible regular expressions.
	{
		"othree/eregex.vim",
		init = function()
			vim.g.eregex_default_enable = false
			vim.g.eregex_force_case = true
		end
	},

	-- Telescope.
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			{ "rcarriga/nvim-notify" },
		},
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
	{ "kevinhwang91/nvim-ufo",  dependencies = "kevinhwang91/promise-async" },

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
	{ "nvim-lualine/lualine.nvim",    dependencies = "nvim-tree/nvim-web-devicons" },

	-- Terminal.
	{ "chengzeyi/multiterm.vim" },

	-- Leap to specific positions in text.
	{ "ggandor/leap.nvim" },

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
	{ "rcarriga/nvim-dap-ui",         dependencies = "mfussenegger/nvim-dap" },

	-- LSPs.
	-- Mason LSP/DAP/linter/formatter package manager.
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate", -- :MasonUpdate updates registry contents
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",

			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",

			-- Signature autocompletion.
			{
				"ray-x/lsp_signature.nvim",
				event = "VeryLazy",
			},

			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",

			-- Completion for neovim lua.
			"folke/neodev.nvim",

			-- LSP progress.
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				event = "LspAttach",
			},
		},
	},

	-- LSP saga.
	{
		'nvimdev/lspsaga.nvim',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'nvim-tree/nvim-web-devicons',
		}
	},

	-- REST tools (Postman alternative).
	{
		"rest-nvim/rest.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Database tools.
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
	},

	-- Rust tools.
	{ "simrat39/rust-tools.nvim" },

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
