# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a kitty terminal configuration repository that manages terminal appearance and behavior through configuration files and themes.

## Key Files

- `kitty.conf` - Main configuration file with extensive inline documentation
- `current-theme.conf` - Symlink to the active theme file
- `themes/dark/*.conf` - Collection of dark color themes

## Common Tasks

### Changing the Active Theme
To switch themes, update the `current-theme.conf` symlink:
```bash
ln -sf themes/dark/ThemeName.conf current-theme.conf
```

### Theme File Structure
Each theme file contains color definitions following this pattern:
- `background` and `foreground` - Main colors
- `cursor` and `cursor_text_color` - Cursor appearance
- `color0` through `color15` - Terminal color palette
- `selection_foreground` and `selection_background` - Text selection colors

## Configuration Architecture

The configuration uses a modular approach:
1. `kitty.conf` contains all behavioral settings (fonts, keyboard, mouse, etc.)
2. Color theming is separated into individual theme files
3. The active theme is included via `include current-theme.conf`

This separation allows easy theme switching without modifying the main configuration.

## Important Settings

Current key configurations:
- Font: Dank Mono, 16pt with 175% line height
- Background opacity: 0.95 (5% transparency)
- Cursor: Red (#ff0000) with white text, no blinking
- macOS: Option key acts as Alt

## Development Notes

- No build/test/lint commands - this is a pure configuration repository
- Changes to kitty.conf require restarting kitty to take effect
- Theme changes can be reloaded with Ctrl+Shift+F5 in kitty
- The repository is part of a larger personal settings collection

## Configuration Understanding

- Use context7 to understand the kitty configuration syntax