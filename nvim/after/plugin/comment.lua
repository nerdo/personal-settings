local present, comment = pcall(require, 'Comment')

if not present then
  return
end

comment.setup()

-- Comment with CTRL+/
vim.keymap.set("n", "<leader><leader>", function() require('Comment.api').toggle.linewise.current() end)
vim.keymap.set("v", "<leader><leader>", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")
