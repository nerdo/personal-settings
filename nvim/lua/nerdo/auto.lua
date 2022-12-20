-- Fix issue with netrw buffers not closing
-- https://github.com/tpope/vim-vinegar/issues/13#issuecomment-47133890
-- autocmd FileType netrw setl bufhidden=delete
vim.api.nvim_create_autocmd(
  "FileType", 
  {
    pattern = "netrw",
    command = "setl bufhidden=delete"
  }
)
