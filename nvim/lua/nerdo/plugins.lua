return function(use)
	-- Theme(s).
	use({ "kyoz/purify", rtp = "vim" })

	-- File explorer.
	use("justinmk/vim-dirvish")

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use({ "nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" } })

	-- Keeps parts of the code on screen for context.
	use({ "nvim-treesitter/nvim-treesitter-context", { after = "nvim-treesitter" } })

	use({ "nvim-treesitter/playground", { after = "nvim-treesitter", run = ":TSInstall query" } })

	use("lewis6991/gitsigns.nvim")

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
		},
	})

	-- Rust tools.
	use({
		"simrat39/rust-tools.nvim",
		requires = {
			{ "neovim/nvim-lspconfig" },

			-- For debugging.
			{ "nvim-lua/plenary.nvim" },
			{ "mfussenegger/nvim-dap" },
		},
	})

	-- For formatting code.
	use("jose-elias-alvarez/null-ls.nvim")

	-- Clear search highlighting when done.
	use("romainl/vim-cool")

	-- Align text with spaces easily.
	use("junegunn/vim-easy-align")

	-- Highlights unique characters to jump to in a line.
	use("unblevable/quick-scope")

	-- Automatic detection of tab size.
	use("Darazaki/indent-o-matic")

	-- Inlay hints for type/metadata.
	use("lvimuser/lsp-inlayhints.nvim")

	-- Show indent lines.
	use("lukas-reineke/indent-blankline.nvim")

	-- Automatically close html/jsx tags.
	use("windwp/nvim-ts-autotag")

	-- Comment out lines with keymap.
	use("numToStr/Comment.nvim")

	-- Colorizer for displaying colors in code.
	use("norcalli/nvim-colorizer.lua")

	-- Terminal.
	use({ "akinsho/toggleterm.nvim", tag = "v2.*" })

	-- Display tabs for buffers.
	use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })

	-- Status line.
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Debug adapter.
	use("mfussenegger/nvim-dap")

	-- JSON schema.
	use("b0o/schemastore.nvim")
end
