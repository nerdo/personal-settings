local present, leap = pcall(require, "leap")

if not present then
	return
end

-- Leap caniballizes these two keymaps, which mess with standard vim behavior,
-- but if we define a keymap, it won't overwrite it!
vim.keymap.set({ "x", "o" }, "x", "x", { noremap = true })

leap.add_default_mappings()
