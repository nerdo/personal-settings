return function(use)
	-- Override some colors for purify...
	-- Unfortunately, this seems to be the best place to put this so it doesn't get lost...
	vim.g.purify_override_colors = {
		yellow = { gui = "#f2f2e6", cterm = "Grey" },
	}

	-- Theme(s).
	use({ "kyoz/purify", rtp = "vim" })

	-- File explorer.
	use("justinmk/vim-dirvish")

	-- Git info in file explorer.
	use("kristijanhusak/vim-dirvish-git")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Replace basic vim selection with Telescope.
	use({ "nvim-telescope/telescope-ui-select.nvim" })

	-- Abstract syntax tree that speeds up a lot of neovim operations.
	use({ "nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" } })

	-- Keeps parts of the code on screen for context.
	use({ "nvim-treesitter/nvim-treesitter-context", { after = "nvim-treesitter" } })

	-- A playground for testing Treesitter.
	use({ "nvim-treesitter/playground", { after = "nvim-treesitter", run = ":TSInstall query" } })

	-- Show symbols in gutter for git changes.
	use("lewis6991/gitsigns.nvim")

	-- Git tools.
	use("tpope/vim-fugitive")

	-- Git commit browser.
	use("junegunn/gv.vim")

	-- Display tabs for buffers.
	use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })

	-- Status line.
	-- Note: for some reason this wipes out the NVIM splash screen buffer.
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- LSPs
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },

			-- The rest are my own LSP requirements (NOT required for lsp-zero)

			-- for formatting code
			{ "jose-elias-alvarez/null-ls.nvim" },

			-- Inlay hints for type/metadata.
			{ "lvimuser/lsp-inlayhints.nvim" },
		},
	})

	-- Completion for neovim lua.
	use("folke/neodev.nvim")

	-- LSP diagnostic info.
	use({ "nerdo/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })
	-- use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })

	-- Test runner.
	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",

			-- Test adapters
			"rouge8/neotest-rust",
			"olimorris/neotest-phpunit",
			"marilari88/neotest-vitest",
			"haydenmeade/neotest-jest",
		},
	})

	-- Clear search highlighting when done.
	use("romainl/vim-cool")

	-- Highlights unique characters to jump to in a line.
	use("unblevable/quick-scope")

	-- Leap to specific positions in text.
	use("ggandor/leap.nvim")

	-- Automatic detection of tab size.
	use("Darazaki/indent-o-matic")

	-- Show indent lines.
	use("lukas-reineke/indent-blankline.nvim")

	-- Automatically close html/jsx tags.
	use("windwp/nvim-ts-autotag")

	-- Comment out lines with keymap.
	use("tpope/vim-commentary")

	-- Surround things easily.
	use("tpope/vim-surround")

	-- Case-intelligent serach and replace.
	use("tpope/vim-abolish")

	-- Auto pairing of brackets and suck.
	use("windwp/nvim-autopairs")

	-- Colorizer for displaying colors in code.
	use("norcalli/nvim-colorizer.lua")

	-- Terminal.
	use({ "akinsho/toggleterm.nvim", tag = "v2.*" })

	-- Debug adapter.
	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

	-- JSON schema.
	use("b0o/schemastore.nvim")

	-- Customize buffer delete behavior.
	use("ojroques/nvim-bufdel")

	-- Align text with spaces easily.
	use("junegunn/vim-easy-align")

	-- Symbols outline.
	use("simrat39/symbols-outline.nvim")
end
