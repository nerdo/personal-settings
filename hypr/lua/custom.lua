-- Personal Hyprland customizations.
--
-- Symlinked in as ~/.config/hypr/custom.lua. hyprland.lua requires this file
-- LAST, so anything set here overrides the ML4W defaults — which is the whole
-- point: ML4W replaces its own conf/*.lua files on every update, this file it
-- leaves alone.
--
-- NOTE: the load path moved with the Lua migration. It used to be
-- conf/custom.conf; it is now custom.lua at the TOP level of ~/.config/hypr.

-- SDL version
hl.env("SDL_VIDEODRIVER", "wayland")

-- NVIDIA environment (LIBVA_DRIVER_NAME, __GLX_VENDOR_LIBRARY_NAME)
require("conf.environments.nvidia")

hl.config({
    -- Enable logging for debugging freezes
    debug = {
        disable_logs = false,
    },

    -- Active window highlighting
    general = {
        border_size = 3,
        col = {
            active_border = { colors = { "rgba(ff8c00ff)", "rgba(ff5500ff)" }, angle = 45 },
            inactive_border = outline_variant,
        },
    },

    decoration = {
        dim_inactive = true,
        dim_strength = 0.15,
    },

    -- Input tuning (was in conf/keyboard.conf before ml4w overwrote it).
    -- Overrides input.lua, which ML4W rewrites on update.
    input = {
        sensitivity = -0.2,
        force_no_accel = true,
        natural_scroll = true,
        repeat_delay = 150,
        repeat_rate = 30,
    },

    -- Keep XWayland (most games) at scale 1 so fullscreen sizing/cursor mapping
    -- stays correct across the rotated + 240Hz layout.
    xwayland = {
        force_zero_scaling = true,
    },
})

-- -----------------------------------------------------
-- Primary monitor + multi-display behavior
-- -----------------------------------------------------

-- Pin workspace 1 and the default new-workspace target to the 240Hz ASUS (DP-3).
-- Using desc: so it survives DP port reshuffles. This stops the rotated panel
-- from grabbing workspace 1 at startup.
hl.workspace_rule({
    workspace = "1",
    monitor = "desc:ASUSTek COMPUTER INC PG32UCDP S8LMQS059127",
    default = true,
})

-- Mark the 240Hz DP-3 as the XWayland/X11 *primary* output. Hyprland enumerates
-- XWayland outputs in connector order (DP-2 = id 1, before DP-3 = id 2), so without
-- this, fullscreen games target the vertical DP-2. Running xrandr also forces
-- XWayland up early. See Hyprland issue #1428. Re-run manually if a hotplug resets it.
--
-- exec-once has no direct Lua equivalent; the hyprland.start event is the
-- replacement (same semantics: fires at compositor start, not on config reload).
hl.on("hyprland.start", function()
    hl.exec_cmd("sleep 1 && xrandr --output DP-3 --primary")

    -- Keep the portrait wallpaper on the vertical monitor. ML4W applies one
    -- wallpaper to every output, so DP-2 is overwritten at login and on each
    -- wallpaper change; this watches and puts it back. See the script header.
    hl.exec_cmd("~/personal/settings/hypr/scripts/wallpaper-per-monitor.sh --watch")
end)
