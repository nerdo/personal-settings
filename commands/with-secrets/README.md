# with-secrets

Runs a program with its SecretSpec profile's keys, whoever starts it: a terminal, or a program such as Orca that runs
`gh` directly, with no zsh functions. The keys reach that one run only.

On PATH as `bin/<name>`, symlinks to [`with-secrets`](with-secrets). The name picks the program and the profile;
`npx`, `bun` and `bunx` use `npm`'s. The real program is the first one of that name (without the `+`) on PATH that is
not this file, and SecretSpec starts it: `secretspec run --profile <profile> -- <real program> …`. With no real program
on PATH it exits 127.

| Name | Who gets the keys | Commands |
|---|---|---|
| `<program>` | every caller; another program must run it with its keys | `gh` (Orca's GitHub panel) |
| `<program>+` | a person who types it; plain `<program>` is the program alone | `npm+`, `npx+`, `bun+`, `bunx+`, `jira+`, `semgrep+`, `spock-me+` |

A `#!/usr/bin/env bun` script, or a program that runs `npm`, gets the plain program and no keys.

## Outside zsh

Programs that start a command themselves need this repo's `bin/` first on their PATH:

- **Programs that copy an interactive zsh's PATH**, such as Orca (`zsh -ilc`): `zsh/custom/990-commands` puts `bin/`
  first. Nothing else to do, on Linux or macOS.
- **Linux desktop session and systemd user services:** run [`zsh/bin/install-bin-path`](../../zsh/bin/install-bin-path)
  once per machine. It writes `~/.config/uwsm/env.d/50-settings-bin-first` (read at each desktop login; uwsm hands that
  PATH to every user service, after Omarchy's file put mise's shims first) and
  `~/.config/environment.d/50-settings-bin-first.conf` (user services before any desktop login), each where that
  system exists. On macOS it writes nothing.

When OpenBao cannot be reached, or the keyring is locked (after a reboot with no desktop login), SecretSpec fails and
the program does not start.

## Tests

`zsh commands/with-secrets/with-secrets.test.zsh` and `zsh zsh/tests/install-bin-path.test.zsh` (both run by
`zsh/tests/run`): fake real programs on PATH behind `bin/`, started with `env -i` as a service would, and SecretSpec
reading a fixture instead of OpenBao. The PATH-file tests skip where uwsm or systemd is missing.
