require("nerdo.functions")
require("nerdo.keymap")
require("nerdo.options")
require("nerdo.lazy")
if not vim.g.nerdo_is_headless then
	require("nerdo.gui")
	require("nerdo.workspace")
end
require("nerdo.persistent-undo")
