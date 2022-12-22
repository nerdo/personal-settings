-- Default vi key bindings: https://hea-www.harvard.edu/~fine/Tech/vi.html (try to preserve these...)

-- Set leader.
vim.g.mapleader = " "

-- Save buffer.
vim.keymap.set("n", "<leader>;", "<Cmd>w<CR>")

-- New buffer.
vim.keymap.set("n", "<leader>b", "<Cmd>enew<CR>")

-- Destroy buffer. Also goes to the next buffer for convenience.
vim.keymap.set("n", "<leader>d", "<Cmd>bd<CR><Cmd>bnext<CR>")

-- Save/quit.
vim.keymap.set("n", "<leader>q", "<Cmd>qa<CR>")
vim.keymap.set("n", "<leader>x", "<Cmd>xa<CR>")

-- Tab through buffers.
vim.keymap.set("n", "<Tab>", "<Cmd>bn<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>bp<CR>")

-- Path functions.
vim.keymap.set("n", "<leader>yr", "<Cmd>CpRelPath<CR>")
vim.keymap.set("n", "<leader>ya", "<Cmd>CpAbsPath<CR>")
vim.keymap.set("n", "<leader>R", "<Cmd>ShowRelPath<CR>")
vim.keymap.set("n", "<leader>A", "<Cmd>ShowAbsPath<CR>")

-- Split navigation with Alt+nav keys.
vim.keymap.set("n", "<A-h>", "<Cmd>wincmd h<CR>")
vim.keymap.set("n", "<A-j>", "<Cmd>wincmd j<CR>")
vim.keymap.set("n", "<A-k>", "<Cmd>wincmd k<CR>")
vim.keymap.set("n", "<A-l>", "<Cmd>wincmd l<CR>")

-- Split resizing with Alt+Shift+nav keys.
vim.keymap.set("n", "<A-S-h>", "<Cmd>vertical resize -1<CR>")
vim.keymap.set("n", "<A-S-j>", "<Cmd>resize +1<CR>")
vim.keymap.set("n", "<A-S-k>", "<Cmd>resize -1<CR>")
vim.keymap.set("n", "<A-S-l>", "<Cmd>vertical resize +1<CR>")

-- Close split
vim.keymap.set("n", "<leader><BS>", "<Cmd>close<CR>")
