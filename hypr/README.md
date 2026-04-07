# Setup

* Using [ML4W Dotfiles](https://github.com/mylinuxforwork/dotfiles) for Hyprland base configuration
* Symlink custom config files into the ML4W Hyprland config directory:
  * `ln -s ~/personal/settings/hypr/conf/custom.conf ~/.config/hypr/conf/custom.conf`
  * `ln -s ~/personal/settings/hypr/conf/nerdo-keybindings.conf ~/.config/hypr/conf/keybindings/nerdo.conf`
  * `ln -s ~/personal/settings/hypr/conf/keybinding.conf ~/.config/hypr/conf/keybinding.conf`
  * `ln -s ~/personal/settings/hypr/conf/monitors.conf ~/.config/hypr/monitors.conf`

## Customization strategy

All Hyprland customizations live in `conf/custom.conf`, which ML4W sources last
and leaves alone across updates. Things that go there: keybinding source,
`input {}` tuning, colors, decoration tweaks, env vars.

Things ML4W overwrites on update (put customizations in `custom.conf` instead
of editing these directly):
* `conf/keybinding.conf` — ml4w resets it to source `default.conf`. Symlinked
  to this repo so it sources only `nerdo.conf` (otherwise bindings fire twice,
  e.g. super+enter opens two terminals).
* `conf/keyboard.conf` — mouse/keyboard tuning resets. Lives in `custom.conf`
  as an `input {}` block.
* `monitors.conf` — gets emptied on update. Symlinked to this repo so
  nwg-displays writes flow back here.
