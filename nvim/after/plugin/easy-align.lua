-- Set keymap for easy align.
vim.keymap.set(
  "n",
  "<leader>a",
  function()
    vim.cmd.LiveEasyAlign()
    print(" ") -- clear the status message
  end
)
