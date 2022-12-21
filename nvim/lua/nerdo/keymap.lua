-- Default vi key bindings: https://hea-www.harvard.edu/~fine/Tech/vi.html (try to preserve these...)

-- Set leader.
vim.g.mapleader = " "

-- Open file explorer `:Explore`.
vim.keymap.set("n", "<leader>f", vim.cmd.Ex)

-- Save/close buffer.
vim.keymap.set("n", "<leader>;", "<cmd>w<CR>")
vim.keymap.set("n", "<leader><CR>", "<cmd>w<CR>:bd<CR>")
vim.keymap.set("n", "<leader><BS>", "<cmd>bd<CR>")

-- Save/quit.
vim.keymap.set("n", "<leader>q", "<cmd>qa<CR>")
vim.keymap.set("n", "<leader>x", "<cmd>xa<CR>")

-- Tab through buffers.
vim.keymap.set("n", "<Tab>", "<cmd>bn<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bp<CR>")

-- Path functions.
vim.keymap.set("n", "<leader>yr", "<cmd>CpRelPath<CR>")
vim.keymap.set("n", "<leader>ya", "<cmd>CpAbsPath<CR>")
vim.keymap.set("n", "<leader>R", "<cmd>ShowRelPath<CR>")
vim.keymap.set("n", "<leader>A", "<cmd>ShowAbsPath<CR>")
