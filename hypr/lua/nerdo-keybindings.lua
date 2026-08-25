-- -----------------------------------------------------
-- Key bindings
-- name: "nerdo"
-- -----------------------------------------------------
--
-- Converted from nerdo-keybindings.conf with hyprlang2lua (Hyprland 0.56 Lua API).
-- Loaded via conf/keybinding.lua, which selects this variant instead of ML4W's
-- default.lua. Do NOT also load default.lua — bindings would fire twice.
--
-- Descriptions are load-bearing: scripts/keybindings.sh (SUPER+CTRL+K) renders
-- `hyprctl binds -j` filtered on `.description != ""`. A bind without one is
-- invisible in that menu.

-- Modifiers
-- mainMod  — workspaces, launchers, Linux-only WM actions
-- navMod   — move focus to adjacent window/display element
-- moveMod  — mutate focused window in place (swap)
-- wmMod    — window state toggles + cross-display focus
-- shipMod  — ship the focused window across displays
local mainMod = "SUPER"
local navMod = "ALT"
local moveMod = "ALT + SHIFT"
local wmMod = "ALT + CTRL"
local shipMod = "ALT + SHIFT + CTRL"
local HYPRSCRIPTS = "~/.config/hypr/scripts"
local SCRIPTS = "~/.config/ml4w/scripts"
-- Custom scripts live in the personal settings repo, not in the ML4W tree —
-- ~/.config/hypr/scripts is replaced wholesale on every ML4W update.
local MYSCRIPTS = "~/personal/settings/hypr/scripts"

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("~/.config/ml4w/settings/terminal.sh"), { description = "Open the terminal" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/ml4w/settings/browser.sh"), { description = "Open the browser" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/filemanager.sh"), { description = "Open the filemanager" })
hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("~/.config/ml4w/settings/emojipicker.sh"), { description = "Open the emoji picker" })
hl.bind(mainMod .. " + CTRL + C", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh"), { description = "Open the calculator" })

-- Display
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(awk \"BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}\")"), { description = "Increase display zoom" })
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(awk \"BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}\")"), { description = "Decrease display zoom" })
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"), { description = "Reset display zoom" })

-- Windows
hl.bind(wmMod .. " + Q", hl.dsp.window.close(), { description = "Close active window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"), { description = "Quit active window and all open instances" })
hl.bind(wmMod .. " + RETURN", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle fullscreen" })
hl.bind(wmMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle maximize" })
hl.bind(wmMod .. " + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
-- The Lua API has no typed mapping for the `workspaceopt` dispatcher. This script
-- shells out to `hyprctl dispatch workspaceopt allfloat`, which still works, and
-- adds the ML4W notification.
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/toggleallfloat.sh"), { description = "Toggle all windows into floating mode" })
hl.bind(wmMod .. " + O", hl.dsp.layout("togglesplit"), { description = "Toggle split orientation (dwindle)" })

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

-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with the mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with the mouse" })

-- Resize active window with keyboard
hl.bind(wmMod .. " + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { description = "Increase window width" })
hl.bind(wmMod .. " + left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { description = "Reduce window width" })
hl.bind(wmMod .. " + down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { description = "Increase window height" })
hl.bind(wmMod .. " + up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { description = "Reduce window height" })

-- Cycle windows.
-- The .conf bound ALT+Tab twice (cyclenext, then bringactivetotop) and relied on
-- both firing. hl.bind takes one dispatcher per key, so the pair is combined into
-- a single closure instead.
hl.bind(navMod .. " + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end, { repeating = true, description = "Cycle between windows" })

-- Actions
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland configuration" })
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/toggle-animations.sh"), { description = "Toggle animations" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh"), { description = "Take a screenshot" })
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh --instant"), { description = "Take an instant full-screen screenshot" })
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh --instant-area"), { description = "Take an instant area screenshot" })
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd(SCRIPTS .. "/wlogout.sh"), { description = "Start wlogout" })
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/waypaper.sh --random"), { description = "Change the wallpaper" })
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/waypaper.sh"), { description = "Open wallpaper selector" })
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/wallpaper-automation.sh"), { description = "Start random wallpaper script" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -replace -i"), { description = "Open application launcher" })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/keybindings.sh"), { description = "Show keybindings" })
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/waybar/launch.sh"), { description = "Reload waybar" })
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("~/.config/waybar/toggle.sh"), { description = "Toggle waybar" })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/loadconfig.sh"), { description = "Reload hyprland config" })
-- Custom cliphist wrapper that doesn't clear the clipboard on escape.
-- The .conf pointed at ~/.config/hypr/nerdo/scripts/cliphist.sh, which has never
-- existed — repointed at the real location in the personal settings repo.
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(MYSCRIPTS .. "/cliphist.sh"), { description = "Open clipboard manager" })
hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd("~/.config/waybar/themeswitcher.sh"), { description = "Open waybar theme switcher" })
hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("flatpak run com.ml4w.settings"), { description = "Open ML4W Dotfiles Settings app" })
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/gamemode.sh"), { description = "Toggle game mode" })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/power.sh lock"), { description = "Lock the screen" })
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/hyprshade.sh"), { description = "Toggle Hyprshade" })
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(SCRIPTS .. "/focus.sh"), { description = "Open Select Window Menu" })

-- Sidepad
-- hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd(SCRIPTS .. "/sidepad.sh"), { description = "Open Sidepad" })
-- hl.bind(mainMod .. " + CTRL + left", hl.dsp.exec_cmd(SCRIPTS .. "/sidepad.sh --hide"), { description = "Close Sidepad" })
-- hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(SCRIPTS .. "/sidepad.sh --init"), { description = "Init Sidepad" })
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(SCRIPTS .. "/sidepad.sh --select"), { description = "Select Sidepad" })

-- Workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Open workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move active window to workspace " .. i })
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.exec_cmd(HYPRSCRIPTS .. "/moveTo.sh " .. i), { description = "Move all windows to workspace " .. i })
end

hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }), { description = "Open next workspace" })
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }), { description = "Open previous workspace" })

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Open next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Open previous workspace" })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }), { description = "Open the next empty workspace" })

-- Fn keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q s +10%"), { description = "Increase brightness by 10%" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"), { description = "Reduce brightness by 10%" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true, description = "Increase volume by 2%" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true, description = "Reduce volume by 2%" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { description = "Toggle mute" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Audio play pause" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"), { description = "Audio pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Audio next" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Audio previous" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { description = "Toggle microphone" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh"), { description = "Open calculator" })
-- Was XF86Lock in the .conf, which is not a keysym xkbcommon knows — Hyprland
-- rejected it with "Unknown keysym". XF86ScreenSaver is the real one.
hl.bind("XF86ScreenSaver", hl.dsp.exec_cmd("hyprlock"), { description = "Open screenlock" })
hl.bind("XF86Tools", hl.dsp.exec_cmd("flatpak run com.ml4w.settings"), { description = "Open ML4W Dotfiles Settings app" })

hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s +10"), { description = "Increase keyboard backlight" })
hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d smc::kbd_backlight s 10-"), { description = "Reduce keyboard backlight" })

-- Overlay workspace
hl.bind(mainMod .. " + O", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle overlay" })
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/shuttle-window-overlay.sh"), { description = "Shuttle window in/out of overlay" })
