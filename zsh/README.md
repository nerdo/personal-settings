# zsh

Cross-platform zsh configuration that works alongside ml4w on Arch Linux
and standalone on macOS.

## Setup

```sh
ln -sf ~/personal/settings/zsh/zshenv ~/.zshenv
exec zsh
```

That is the whole install. `~/.zshrc` links itself on the next shell, and
re-links itself after an ml4w update — see [Surviving ml4w](#surviving-ml4w).

## How it works

Two entry points, because ml4w owns one of them and not the other.

### `zsh/zshenv` → `~/.zshenv` (every shell)

zsh reads `~/.zshenv` for **every** invocation — interactive, non-interactive,
and scripts. ml4w ships no `.zshenv`, so nothing it does can clobber this file.
It does two things:

- Loads `custom/100-secrets`, which exports one env var per file in
  `~/.secrets/export/` (filename → var name, contents → value). Because this
  runs outside `.zshrc`, the values also reach scripts, editors, and tools
  started outside a login shell.
- Repairs `~/.zshrc` when it is not pointing at this repo's loader.

Keep this path to exports that print nothing and assume no terminal. Aliases,
prompts, and keybindings need an interactive shell and belong in `custom/`.

### `zsh/zshrc` → `~/.zshrc` (interactive shells)

A loader that merges two module directories and sources them in number order:

- `~/.config/zshrc/` — on Arch, ml4w manages files here (aliases, autostart, etc.)
- this repo's `custom/` — resolved from the loader's own path, not through
  `~/.config/zshrc/custom`

When both sides hold the same module, `custom/` wins. Modules only in `custom/`
are also sourced — the additions ml4w's own loader cannot do.

On macOS (no ml4w), `~/.config/zshrc/` does not exist and everything loads from
`custom/`.

## Surviving ml4w

Both of the loader's original paths were symlinks into ml4w's own tree:

```
~/.zshrc        → ~/.mydotfiles/com.ml4w.dotfiles.stable/.zshrc
~/.config/zshrc → ~/.mydotfiles/com.ml4w.dotfiles.stable/.config/zshrc
   └── custom   → ~/personal/settings/zsh/custom
```

An ml4w update rewrites that tree. It reverts `~/.zshrc` to ml4w's own loader,
and it can take the `custom` symlink with it — that symlink lives inside the
directory ml4w replaces. ml4w's loader supports 1:1 overrides only: it walks
`~/.config/zshrc/*` and swaps in a same-named `custom/` file, so modules that
exist **only** in `custom/` never run under it.

Two things make that harmless now:

- **The loader resolves `custom/` from its own path.** The
  `~/.config/zshrc/custom` symlink is no longer load-bearing; it can vanish.
- **`~/.zshenv` re-links `~/.zshrc`.** zsh reads `.zshenv` before `.zshrc`, so
  the repair lands in the shell that noticed it, not the one after. There is no
  manual step after an ml4w update.

Set `ZSHRC_NO_SELF_HEAL=1` to leave `~/.zshrc` alone and run ml4w's loader as it
ships — useful for reproducing a bug against stock ml4w.

## File numbering convention

Modules are sourced in sorted order, and ml4w's modules sort into the same
number line as this repo's. Use 3-digit prefixes:

| Prefix  | Purpose                                      |
|---------|----------------------------------------------|
| `000-`  | Init, exports, PATH                          |
| `020-`  | Shell setup (oh-my-zsh, prompt, history)     |
| `100-`  | Tool integrations (zoxide, barnacle...)      |
| `200-`  | Language environments (nvm, pyenv, rust...)  |
| `500-`  | Keybindings                                  |
| `900-`  | Aliases                                      |

Two traps live in that sort:

**Sorting is the locale's collation, not byte order.** Under `en_US.UTF-8` the
`-` is ignored, so `200-bun` sorts *before* `20-customization`. ml4w's four
modules therefore land like this:

```
00-init  010-path  020-customization  100-*  200-*  25-aliases  30-autostart  500-*  900-*
                                                    └── ml4w ──┘
```

A module that has to beat an ml4w default needs a number above ml4w's own —
which is why the eza aliases live in `900-eza` and not in the `100-` tool tier:
ml4w's `25-aliases` also aliases `ls`.

**ml4w numbers with two digits where this repo zero-pads to three.** Name
matching alone would never pair `custom/020-customization` with ml4w's
`20-customization`, so both would run — oh-my-zsh, fzf, and the prompt set up
twice, with ml4w's prompt landing last and winning. The loader collapses the
padding so the two share one slot, and the zero-padded name sorts first, so
`custom/` claims it. Name a module to match the ml4w module it replaces, padding
aside, and the replacement is automatic.

## Adding a new module

Create a file in `zsh/custom/` with the appropriate number prefix. It will be
picked up automatically on both platforms — no symlink changes needed.

## Tests

```sh
zsh/tests/run
```

`custom/` is a load path, not a test path: a file placed there is sourced at
every shell startup, so suites live in `zsh/tests/` instead. The `zshenv` and
`zshrc` suites build a throwaway `$HOME` and a stub repo and start real shells
under `env -i`, so they exercise the post-ml4w-update case without touching the
real dotfiles.

## oh-my-posh theme

The `POSH` variable in `custom/020-customization` controls the prompt theme. If
the theme isn't found locally or in system paths, it is auto-downloaded from the
oh-my-posh built-in themes.
