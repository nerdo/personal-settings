-- Load the "nerdo" keybinding variant instead of ML4W's default.
--
-- ML4W resets conf/keybinding.lua to load default.lua on every update, so this
-- file is symlinked in from ~/personal/settings/hypr/lua/. It loads ONLY
-- nerdo.lua — loading default.lua as well makes bindings fire twice (e.g.
-- super+enter opens two terminals).

local name = "nerdo.lua"
load_variant(name, "keybindings")
