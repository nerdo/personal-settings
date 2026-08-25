-- Monitor layout. Symlinked in as ~/.config/hypr/monitors.lua so that both ML4W
-- updates and nwg-displays writes flow back into this repo instead of being lost.
--
-- WARNING: nwg-displays rewrites this file on save and has a habit of shifting
-- the whole layout off the origin (it last wrote DP-2 at -1x-1 and DP-3 at
-- 2160x1680). If workspace 1 starts landing on the rotated panel, that is the
-- symptom — check the positions below first.
--
-- DP-3 = ASUS PG32UCDP 240Hz, primary, anchored at the origin (0,0).
-- DP-2 = XHS 4K@120, rotated 90deg (portrait), to the LEFT of and bottom-aligned
--        with DP-3. Rotated, so it occupies 2160 wide x 3840 tall: x = -2160
--        puts its right edge at DP-3's left edge, y = -1680 puts its bottom edge
--        level with DP-3's bottom (2160 - 3840 = -1680).

hl.monitor({
    output = "HDMI-A-1",
    disabled = true,
})

hl.monitor({
    output = "DP-3",
    mode = "3840x2160@240.02",
    position = "0x0",
    scale = 1.0,
})

hl.monitor({
    output = "DP-2",
    mode = "3840x2160@119.88",
    position = "-2160x-1680",
    scale = 1.0,
    transform = 1,
})
