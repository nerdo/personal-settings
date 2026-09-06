-- Monitor layout. Symlinked in as ~/.config/hypr/monitors.lua so that both ML4W
-- updates and nwg-displays writes flow back into this repo instead of being lost.
--
-- LAYOUT IS NORMALIZED TO THE ORIGIN ON PURPOSE. Keep the top-left corner of the
-- bounding box at (0,0) — i.e. no monitor may have a negative x or y.
-- nwg-displays draws each output on a Gtk.Fixed at its raw Hyprland coordinate
-- times the view scale, with no normalization (nwg_displays/main.py, the
-- fixed.put(b, x * view-scale, y * view-scale) call). A monitor at a negative
-- coordinate lands off the top-left of the canvas and GTK clips it, so it simply
-- does not appear in the GUI. Anchoring DP-3 at 0x0 pushed DP-2 to -2160x-1680
-- and made the rotated panel invisible there; that is also why nwg-displays kept
-- rewriting the layout shifted — it was normalizing what it could actually draw.
--
-- DP-2 = XHS XR32UMH, rotated 90deg (portrait), anchored at the origin. Rotated,
--        so it occupies 2160 wide x 3840 tall.
-- DP-3 = ASUS PG32UCDP 240Hz, primary, to the RIGHT of and bottom-aligned with
--        DP-2: x = 2160 puts its left edge at DP-2's right edge, y = 1680 puts
--        its bottom edge level with DP-2's bottom (3840 - 2160 = 1680).
--
-- DP-3 no longer needs to sit at 0x0 to win workspace 1 — custom.lua pins
-- workspace 1 to DP-3 by desc:, which is position-independent.

hl.monitor({
    output = "HDMI-A-1",
    disabled = true,
})

hl.monitor({
    output = "DP-2",
    mode = "3840x2160@120.00",
    position = "0x0",
    scale = 1.0,
    transform = 1,
})

hl.monitor({
    output = "DP-3",
    mode = "3840x2160@240.02",
    position = "2160x1680",
    scale = 1.0,
})
