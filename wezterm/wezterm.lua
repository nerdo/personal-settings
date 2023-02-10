local wezterm = require("wezterm")
return {
	disable_default_key_bindings = true,
	adjust_window_size_when_changing_font_size = false,
	enable_tab_bar = false,
	window_background_opacity = 0.85,
	text_background_opacity = 1.0,
	font = wezterm.font_with_fallback({
		"Dank Mono",
		"Hack Nerd Font Mono",
		"PowerlineExtraSymbols",
		"Noto Color Emoji",
	}),
	font_load_target = "Light",
	font_size = 18,
	color_scheme = "Brogrammer",
	colors = {
		background = "black",
	},

	-- make both left and right alt behave in the same, normal, way
	-- https://wezfurlong.org/wezterm/config/keyboard-concepts.html?highlight=right%20option#macos-left-and-right-option-key
	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = false,

	keys = {
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
		{ key = "0", mods = "CTRL", action = "ResetFontSize" },

		-- MacOS keybindings
		{ key = "v", mods = "CMD", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "c", mods = "CMD", action = "Copy" },
		{ key = "m", mods = "CMD", action = "Hide" },
		{ key = "q", mods = "CMD", action = "QuitApplication" },
		{ key = "0", mods = "CMD", action = "ResetFontSize" },
		{ key = "=", mods = "CMD", action = "IncreaseFontSize" },
		{ key = "-", mods = "CMD", action = "DecreaseFontSize" },
	},
}
