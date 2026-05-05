# Window Manager Keybindings

Cross-platform unified keybindings for Hyprland (Linux) and yabai/skhd (macOS).
Same physical keys do the same thing on both systems wherever a meaningful
parity exists.

## Modifier philosophy

Two namespaces never overlap, so one modifier ladder covers everything:

- **Directional namespace** — `h/j/k/l` and arrow keys
- **Action namespace** — letters / `Return` / `Tab`

Modifier ladder:

| Variable | Combo | Role |
|---|---|---|
| `nav` | `ALT` | Move focus to adjacent window/display element |
| `move` | `ALT+SHIFT` | Mutate focused window in place (swap) |
| `wm` | `ALT+CTRL` | Window state toggles + cross-display focus |
| `ship` | `ALT+SHIFT+CTRL` | Ship focused window across displays |
| `mainMod` | `SUPER` (Linux only) | Workspaces, launchers, system actions |

`ALT+CTRL` carries both state toggles (action namespace) and display focus
(directional namespace) — no collision because the trigger keys are disjoint.

`SUPER`/`cmd` is reserved for Linux-only WM actions. Plain `cmd+letter` on
macOS collides with virtually every app shortcut, so it's not a parity
candidate.

## Window navigation (within space)

| Action | Binding |
|---|---|
| Focus window L / D / U / R | `nav - h / j / k / l` |
| Swap window L / D / U / R | `move - h / j / k / l` |
| Cycle windows in space | `nav - Tab` |

skhd note: focus and swap include a fallback to the next display when no
adjacent window exists. swap also moves the window across displays in that
case.

## Display navigation (multi-monitor)

| Action | Binding |
|---|---|
| Focus display L / D / U / R | `wm - h / j / k / l` |
| Move window to display | `ship - h / j / k / l` |

## Window state

| Action | Binding |
|---|---|
| Toggle floating | `wm - f` |
| Toggle fullscreen | `wm - Return` |
| Toggle maximize | `wm - m` |
| Toggle split orientation | `wm - o` |
| Close active window (not whole app on macOS) | `wm - q` |
| Resize active window L / R / D / U | `wm - left / right / down / up` |

## Linux-only (Hyprland workspaces)

macOS Spaces have no clean parity — `cmd+Tab` is system-reserved for
app-switching, and numeric Space jumps collide with app shortcuts.

| Action | Binding |
|---|---|
| Switch to workspace 1–10 | `SUPER - 1..0` |
| Move active window to workspace | `SUPER+SHIFT - 1..0` |
| Move all windows to workspace | `SUPER+CTRL - 1..0` |
| Next workspace (per-monitor) | `SUPER - Tab` |
| Previous workspace (per-monitor) | `SUPER+SHIFT - Tab` |
| Empty workspace | `SUPER+CTRL - down` |
| Toggle special workspace | `SUPER - O` |
| Shuttle window in/out of overlay | `SUPER+SHIFT - O` |
| Mouse wheel: next/prev workspace | `SUPER + scroll` |

## macOS-only (yabai-specific)

Hyprland has no direct equivalent for these.

| Action | Binding |
|---|---|
| Warp/re-tile window L / D / U / R | `SHIFT+CTRL - h / j / k / l` |
| Balance space | `wm - b` |
| Toggle bsp ↔ stack layout | `wm - s` |

## Conflict avoidance rationale

The `wm` modifier is `ALT+CTRL` (`option+ctrl` on macOS) because:

- **macOS**: `cmd+letter` collides with virtually every app shortcut
  (`cmd+H` hide, `cmd+M` minimize, `cmd+F` find, `cmd+Q` quit, `cmd+T` new
  tab, `cmd+G` find-next). Even `cmd+shift+letter` is busy in major apps
  (`cmd+shift+F` = find-in-files in VSCode/Slack, `cmd+shift+T` = reopen
  tab). `cmd+ctrl+arrows` is reserved for Mission Control space switching.
  `option+ctrl+letter` is rarely app-bound and never system-reserved.
- **Linux**: GTK/Qt menu mnemonics live on plain `ALT+letter`. `ALT+CTRL+letter`
  is free in apps. Hyprland binds at compositor level, so the binding wins
  regardless, but keeping the slot off `ALT+letter` preserves menu access in
  apps the WM doesn't intercept.

The `nav`/`move` modifiers are `ALT`/`ALT+SHIFT` because that's where the
existing focus and swap bindings already lived on both sides — the parity
was already most of the way there.

## Source files

- Linux: [hypr/conf/nerdo-keybindings.conf](hypr/conf/nerdo-keybindings.conf)
- macOS:
  - [skhd/skhdrc](skhd/skhdrc) — keybindings
  - [yabai/yabairc](yabai/yabairc) — yabai daemon config (layout, padding,
    rules, mouse modifier)
