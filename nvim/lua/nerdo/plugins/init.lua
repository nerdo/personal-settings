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
end
