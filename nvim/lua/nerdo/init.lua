if vim.g.vscode then
	-- Only load keymaps when running vscode.
	-- Plugins and other stuff get in the way of it running properly.
	require("nerdo.keymap")
else
	require("nerdo.functions")
	require("nerdo.keymap")
	require("nerdo.options")
	require("nerdo.lazy")
	require("nerdo.gui")
	require("nerdo.workspace")
	require("nerdo.persistent-undo")
end
