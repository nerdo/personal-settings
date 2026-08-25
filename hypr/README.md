# Setup

* Using [ML4W Dotfiles](https://github.com/mylinuxforwork/dotfiles) for Hyprland base configuration
* Symlink custom config files into the ML4W Hyprland config directory:
  * `ln -s ~/personal/settings/hypr/lua/custom.lua ~/.config/hypr/custom.lua`
  * `ln -s ~/personal/settings/hypr/lua/nerdo-keybindings.lua ~/.config/hypr/conf/keybindings/nerdo.lua`
  * `ln -s ~/personal/settings/hypr/lua/keybinding.lua ~/.config/hypr/conf/keybinding.lua`
  * `ln -s ~/personal/settings/hypr/lua/monitors.lua ~/.config/hypr/monitors.lua`

## Lua migration (Hyprland 0.55+)

Hyprland deprecated hyprlang (`.conf`) in favour of Lua. **If `hyprland.lua`
exists, `hyprland.conf` is never read** — the check happens once at startup, so
switching formats needs a full restart, not a reload.

ML4W shipped its `.lua` tree in the August 2026 update. That silently orphaned
every `.conf` symlink, because the load paths moved:

| Old (`.conf`)                 | New (`.lua`)                          |
|-------------------------------|---------------------------------------|
| `conf/custom.conf`            | `custom.lua` — **top level**, not `conf/` |
| `conf/keybinding.conf`        | `conf/keybinding.lua`                 |
| `conf/keybindings/nerdo.conf` | `conf/keybindings/nerdo.lua`          |
| `monitors.conf`               | `monitors.lua`                        |

The stale `.conf` files are still on disk and are dead weight — they are kept
only as a translation reference.

Converting more `.conf` by hand is unnecessary; `hyprlang2lua` (AUR) targets the
0.56 API:

```bash
hyprlang2lua --report old.conf -o new.lua
```

Two things it gets wrong, both of which cause silent breakage — check for them
after every conversion:

1. **Multi-modifier variables.** It emits `"ALT SHIFT"`; the Lua key parser
   requires `"ALT + SHIFT"`. Without the `+` the bind is dropped with
   `Unknown keysym` in `hyprctl configerrors`.
2. **Dropped `description` fields.** `scripts/keybindings.sh` (SUPER+CTRL+K)
   renders `hyprctl binds -j` filtered on `.description != ""`. Binds converted
   without descriptions vanish from that menu even though they still work.

It also drops `{ mouse = true }` on `bindm` mouse binds, and cannot map the
`workspaceopt` dispatcher (no typed Lua equivalent — shell out via
`hyprctl dispatch workspaceopt allfloat` instead).

Note that `hyprctl dispatch` now takes Lua too:
`hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'`.

## Customization strategy

All Hyprland customizations live in `custom.lua`, which ML4W requires last and
leaves alone across updates. Things that go there: `input {}` tuning, colors,
decoration tweaks, env vars, workspace rules.

`exec-once` has no Lua equivalent — use the start event instead:

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("...")
end)
```

Things ML4W overwrites on update (put customizations in `custom.lua` instead
of editing these directly):
* `conf/keybinding.lua` — ml4w resets it to load `default.lua`. Symlinked
  to this repo so it loads only `nerdo.lua` (otherwise bindings fire twice,
  e.g. super+enter opens two terminals).
* `input.lua` — mouse/keyboard tuning resets. Lives in `custom.lua`
  as an `input` block inside `hl.config`.
* `monitors.lua` — gets emptied on update. Symlinked to this repo so
  nwg-displays writes flow back here.

## Gotchas

* **nwg-displays breaks the origin.** It rewrites `monitors.lua` on save and has
  twice shifted the whole layout off `0,0` (last time: DP-2 at `-1x-1`, DP-3 at
  `2160x1680`). Symptom is workspace 1 opening on the rotated panel. DP-3 must
  sit at `0x0`.
* **Custom scripts belong in this repo**, not `~/.config/hypr/scripts` — ML4W
  replaces that directory wholesale on update.
* **SUPER+Tab is bound twice** (`focus.sh` and `workspace m+1`), inherited from
  the old `.conf`. Both register; the first one registered wins.
