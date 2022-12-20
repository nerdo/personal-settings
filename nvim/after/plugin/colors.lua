-- Set cursor line colors.
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = "DarkBlue", bg = "#162F5A" })
vim.api.nvim_set_hl(0, "CursorLineNr", { ctermfg = "yellow", fg = "yellow", ctermbg = "DarkBlue", bg = "#0841A1" })

-- Set gutter line number colors.
vim.api.nvim_set_hl(0, "LineNrAbove", { ctermfg = "red", fg = "#C46EA2" })
vim.api.nvim_set_hl(0, "LineNrBelow", { ctermfg = "green", fg = "#6EC48B" })

-- Set visual highlight.
vim.api.nvim_set_hl(0, "Visual", { ctermbg = "Grey", bg = "#044A4E" })

-- Set highlight group for importing TS types for a nice visual distinction.
vim.api.nvim_set_hl(0, "TSConstructor", { fg = "#25888E" })
