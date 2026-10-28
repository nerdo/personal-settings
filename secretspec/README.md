# secretspec

Dannel's keys, loaded per command from OpenBao (`kv/dannel/…` on `scrts.strflt.com`) instead of exported into every
shell. Names and paths only; values never live in this repository.

- [`secretspec.toml`](secretspec.toml): one profile per command (`claude`, `claude-tsi`, `harness` for omp and dsh,
  `npm` for npm/npx/bun/bunx, `jira`, `semgrep`, `spock-me`), and on-demand profiles no command loads by itself
  (`openai`, `slack`, `coolify`, `github-mcp`): `with_secrets openai <command>`. Login: the `dannel` AppRole login SecretSpec reads from
  the Keychain (`strflt-openbao-dannel`); cache: the keyring, 1 day.
- [`aliases.zsh`](aliases.zsh): `with_secrets PROFILE PROGRAM [ARGS…]` and the command wrappers, loaded by
  `zsh/custom/150-secretspec`; `claude`, `claude-tsi`, `omp` and `dsh` in `zsh/custom/900-aliases` use it.
- [`not-exported`](not-exported): the names `zsh/custom/100-secrets` no longer exports.

- [`sec.zsh`](sec.zsh): `sec` to read and change keys in OpenBao without a value on a command line, in history or
  on screen: `sec ls [PATH]`, `sec fields ITEM`, `sec get ITEM FIELD` (clipboard at a terminal, cleared after 45 s;
  stdout in a pipe), `sec set ITEM FIELD` (from a pipe, `pbpaste | sec set …`, or a hidden prompt; keeps the item's
  other fields and clears SecretSpec's cache). Old versions and rollback: the web interface or `bao kv rollback`.

To rotate a key: `pbpaste | sec set <item> <FIELD>`, then check the command that uses it.

To give a command a key: add the name to that command's profile (with `refs` to its OpenBao item and field), add it
to `not-exported` if it is in `~/.secrets/export/`, and run `zsh/tests/run`. `sec set` clears the cache; after
changing a key another way: `secretspec -f secretspec/secretspec.toml cache clear --profile <profile>`.

A new machine needs its own `dannel` AppRole secret in its keyring; see strflt-system-administration
`machines/joker/openbao/dannel/`.
