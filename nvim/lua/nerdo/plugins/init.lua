return function(use)
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'kyoz/purify', rtp = 'vim',
    config = function()
      vim.cmd.colorscheme 'purify'
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' }
  }

  use {
    'nvim-treesitter/nvim-treesitter-context', { after = 'nvim-treesitter' }
  }

  use 'lewis6991/gitsigns.nvim'

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  -- Clear search highlighting when done.
  use 'romainl/vim-cool'

  -- Align text with spaces easily.
  use 'junegunn/vim-easy-align'

  -- Highlights unique characters to jump to in a line.
  use 'unblevable/quick-scope'

  -- Automatic detection of tab size.
  use {
    'Darazaki/indent-o-matic',
    config = function () require('indent-o-matic').setup {} end,
  }

  use 'lvimuser/lsp-inlayhints.nvim'
end
