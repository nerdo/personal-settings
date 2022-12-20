-- Default vi key bindings: https://hea-www.harvard.edu/~fine/Tech/vi.html (try to preserve these...)

-- Set leader.
vim.g.mapleader = " "

-- Open file explorer `:Explore`.
vim.keymap.set("n", "<leader>f", vim.cmd.Ex)

-- Save/close buffer.
vim.keymap.set("n", "<leader>;", ":w<CR>")
vim.keymap.set("n", "<leader><CR>", ":w<CR>:bd<CR>")
vim.keymap.set("n", "<leader>.", ":bd<CR>")

-- Save/quit.
vim.keymap.set("n", "<leader>q", ":qa<CR>")
vim.keymap.set("n", "<leader>x", ":xa<CR>")

-- Tab through buffers.
vim.keymap.set("n", "<Tab>", ":bn<CR>")
vim.keymap.set("n", "<S-Tab>", ":bp<CR>")
