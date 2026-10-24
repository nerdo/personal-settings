-- Personal keybindings for Omarchy.
--
-- Symlinked in as ~/.config/hypr/bindings.lua, which Omarchy's hyprland.lua
-- requires after its own defaults. Ported from ../lua/nerdo-keybindings.lua,
-- keeping only the window-management binds: the ML4W script/app binds don't
-- exist here, and Omarchy already covers workspaces, mouse drag/resize,
-- ALT+Tab cycling and the Fn keys.
--
-- See every active binding: omarchy menu keybindings --print

-- navMod   — move focus to adjacent window
-- moveMod  — mutate focused window in place (swap)
-- wmMod    — window state toggles + cross-display focus
-- shipMod  — ship the focused window across displays
local mainMod = "SUPER"
local navMod = "ALT"
local moveMod = "ALT + SHIFT"
local wmMod = "ALT + CTRL"
local shipMod = "ALT + SHIFT + CTRL"

-- Display zoom
hl.bind(mainMod .. " + SHIFT + mouse_down", function()
    hl.config({ cursor = { zoom_factor = (hl.get_config("cursor.zoom_factor") or 1) + 0.5 } })
end, { description = "Increase display zoom" })
hl.bind(mainMod .. " + SHIFT + mouse_up", function()
    hl.config({ cursor = { zoom_factor = math.max(1, (hl.get_config("cursor.zoom_factor") or 1) - 0.5) } })
end, { description = "Decrease display zoom" })
hl.bind(mainMod .. " + SHIFT + Z", function()
    hl.config({ cursor = { zoom_factor = 1 } })
end, { description = "Reset display zoom" })

-- Windows
hl.bind(wmMod .. " + Q", hl.dsp.window.close(), { description = "Close active window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"), { description = "Quit active window and all open instances" })
hl.bind(wmMod .. " + RETURN", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle fullscreen" })
hl.bind(wmMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle maximize" })
hl.bind(wmMod .. " + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(wmMod .. " + O", hl.dsp.layout("togglesplit"), { description = "Toggle split orientation (dwindle)" })

-- Workspaces, macOS-style: CTRL+arrow steps to the adjacent workspace on this monitor, empty or not
-- ("m±1" would skip empty ones, so with one workspace open it did nothing).
-- Note this takes CTRL+left/right from every app (e.g. word-jump in terminals).
hl.bind("CTRL + left", hl.dsp.focus({ workspace = "r-1" }), { description = "Previous workspace" })
hl.bind("CTRL + right", hl.dsp.focus({ workspace = "r+1" }), { description = "Next workspace" })

-- Window focus (within space)
hl.bind(navMod .. " + h", hl.dsp.focus({ direction = "left" }), { description = "Focus window left" })
hl.bind(navMod .. " + l", hl.dsp.focus({ direction = "right" }), { description = "Focus window right" })
hl.bind(navMod .. " + k", hl.dsp.focus({ direction = "up" }), { description = "Focus window up" })
hl.bind(navMod .. " + j", hl.dsp.focus({ direction = "down" }), { description = "Focus window down" })

-- Window swap (within space)
hl.bind(moveMod .. " + h", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window left" })
hl.bind(moveMod .. " + j", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })
hl.bind(moveMod .. " + k", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind(moveMod .. " + l", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window right" })

-- Display focus (multi-monitor)
hl.bind(wmMod .. " + h", hl.dsp.focus({ monitor = "l" }), { description = "Focus display left" })
hl.bind(wmMod .. " + j", hl.dsp.focus({ monitor = "d" }), { description = "Focus display down" })
hl.bind(wmMod .. " + k", hl.dsp.focus({ monitor = "u" }), { description = "Focus display up" })
hl.bind(wmMod .. " + l", hl.dsp.focus({ monitor = "r" }), { description = "Focus display right" })

-- Move window to display
hl.bind(shipMod .. " + h", hl.dsp.window.move({ monitor = "l" }), { description = "Move window to display left" })
hl.bind(shipMod .. " + j", hl.dsp.window.move({ monitor = "d" }), { description = "Move window to display down" })
hl.bind(shipMod .. " + k", hl.dsp.window.move({ monitor = "u" }), { description = "Move window to display up" })
hl.bind(shipMod .. " + l", hl.dsp.window.move({ monitor = "r" }), { description = "Move window to display right" })

-- Resize active window with keyboard
hl.bind(wmMod .. " + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Increase window width" })
hl.bind(wmMod .. " + left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Reduce window width" })
hl.bind(wmMod .. " + down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { description = "Increase window height" })
hl.bind(wmMod .. " + up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { description = "Reduce window height" })
