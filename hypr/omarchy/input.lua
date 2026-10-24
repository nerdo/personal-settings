-- Personal input tuning for Omarchy.
--
-- Symlinked in as ~/.config/hypr/input.lua, which Omarchy's hyprland.lua
-- requires after its own defaults, so these override them. Same values as the
-- input block in ../lua/custom.lua.
hl.config({
    input = {
        sensitivity = -0.2,
        force_no_accel = true,
        natural_scroll = true,
        repeat_delay = 150,
        repeat_rate = 30,
    },
})
