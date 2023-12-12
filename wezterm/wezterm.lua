local wezterm = require("wezterm")
return {
	disable_default_key_bindings = true,
	adjust_window_size_when_changing_font_size = false,
	enable_tab_bar = false,
	freetype_load_flags = "NO_HINTING",
	font = wezterm.font_with_fallback({
		{
			family = "CaskaydiaCove Nerd Font Mono",
			-- family = "MesloLGS NF",
			-- harfbuzz_features = { "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "zero", "onum" },
		},
	}),
	font_size = 16,
	line_height = 1.6,
	color_scheme = "Argonaut",
	colors = {
		cursor_bg = "#800500",
		cursor_fg = "#eacecd",
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
		{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
		{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "m", mods = "CMD", action = "Hide" },
		{ key = "q", mods = "CMD", action = "QuitApplication" },
		{ key = "0", mods = "CMD", action = "ResetFontSize" },
		{ key = "=", mods = "CMD", action = "IncreaseFontSize" },
		{ key = "-", mods = "CMD", action = "DecreaseFontSize" },
	},
}
