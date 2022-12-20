return function(use)
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'kyoz/purify', rtp = 'vim',
    config = function()
      vim.cmd.colorscheme 'purify'
    end
  }
end
