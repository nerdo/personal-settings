# zsh

Cross-platform zsh configuration that works alongside ml4w on Arch Linux
and standalone on macOS.

## How it works

`zsh/zshrc` is a loader that sources modules from two directories, merged and
sorted by filename:

- `~/.config/zshrc/` — on Arch, ml4w manages files here (aliases, autostart, etc.)
- `~/.config/zshrc/custom/` — your personal modules (this repo's `zsh/custom/`)

When both directories contain a file with the same name, the `custom/` version
wins. Files only in `custom/` are also sourced. This lets ml4w updates flow
through while your overrides and additions stay in version control.

On macOS (no ml4w), `~/.config/zshrc/` is empty and everything loads from
`custom/`.

## Setup

```sh
# Link the loader
ln -sf ~/personal/settings/zsh/zshrc ~/.zshrc

# Link the custom modules folder
mkdir -p ~/.config/zshrc
ln -sf ~/personal/settings/zsh/custom ~/.config/zshrc/custom
```

## File numbering convention

Modules are sourced in sorted order. Use the numbering prefixes to control
load order:

| Range   | Purpose                                      |
|---------|----------------------------------------------|
| `00-`   | Init, exports, PATH                          |
| `20-`   | Shell setup (oh-my-zsh, prompt, history)     |
| `100-`  | Tool integrations (eza, zoxide, starship...) |
| `200-`  | Language environments (nvm, pyenv, rust...)   |
| `500-`  | Keybindings                                  |
| `900-`  | Aliases                                      |

## Adding a new module

Create a file in `zsh/custom/` with the appropriate number prefix. It will be
picked up automatically on both platforms — no symlink changes needed.

## oh-my-posh theme

The `POSH` variable in `20-customization` controls the prompt theme. If the
theme isn't found locally or in system paths, it is auto-downloaded from the
oh-my-posh built-in themes.
