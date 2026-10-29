# with-secrets

Runs a program with its SecretSpec profile's keys, whoever starts it: a terminal, or a program such as Orca that runs
`gh` directly, with no zsh functions. The keys reach that one run only.

On PATH as `bin/<program>`, symlinks to [`with-secrets`](with-secrets): `gh`, `npm`, `npx`, `bun`, `bunx`, `jira`,
`semgrep`, `spock-me`. The name picks the program and the profile; `npx`, `bun` and `bunx` use `npm`'s. The real
program is the first one of that name on PATH that is not this file, and SecretSpec starts it:
`secretspec run --profile <profile> -- <real program> …`. With no real program on PATH it exits 127.

## Outside zsh

[`zsh/bin/link-local-bin`](../../zsh/bin/link-local-bin) links every `bin/` command into `~/.local/bin`, and links the
two files that put `~/.local/bin` first on the PATH of programs started outside zsh:

| File | Linked to | Read |
|---|---|---|
| [`uwsm/env.d/50-local-bin-first`](../../uwsm/env.d/50-local-bin-first) | `~/.config/uwsm/env.d/` | at each desktop login; uwsm then gives this PATH to every user service |
| [`systemd/environment.d/50-local-bin-first.conf`](../../systemd/environment.d/50-local-bin-first.conf) | `~/.config/environment.d/` | when the user's systemd starts, before any desktop login |

Omarchy's own uwsm file puts mise's shims first, which is why both are needed. A file already in `~/.local/bin` (for
example a mise launcher) is moved to `~/.local/share/settings/local-bin-backup/<time>/`.

When OpenBao cannot be reached, or the keyring is locked (after a reboot with no desktop login), SecretSpec fails and
the program does not start.

## Tests

`zsh commands/with-secrets/with-secrets.test.zsh` and `zsh zsh/tests/link-local-bin.test.zsh` (both run by
`zsh/tests/run`): fake real programs on PATH behind `~/.local/bin`, started with `env -i` as a service would, and
SecretSpec reading a fixture instead of OpenBao.
