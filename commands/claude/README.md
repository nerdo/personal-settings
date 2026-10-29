# claude

Starts Claude Code the way Dannel runs it, whoever starts it: a terminal, or a program such as T3 Code. On PATH as
`bin/claude` and `bin/claude-tsi` (symlinks to [`claude`](claude)), and as `~/.local/bin/claude` and `claude-tsi` (from
`zsh/bin/link-local-bin`) for programs outside zsh. It finds the real binary itself: the first `claude` on PATH that
is not this file (on frankenstein, mise's).

| Name | SecretSpec profile | `LANGFUSE_TRACING_ENVIRONMENT` | `CLAUDE_CONFIG_DIR` |
|---|---|---|---|
| `claude` | `claude` | `claude-code-personal` | `~/.claude` |
| `claude-tsi` | `claude-tsi` | `claude-code-tsi` | `~/.claude-tsi` |

A caller's `LANGFUSE_TRACING_ENVIRONMENT` or `CLAUDE_CONFIG_DIR` wins over the default.

## What it does

1. **Same environment as a terminal.** Started outside an interactive shell (no `SETTINGS_ZSHRC_LOADED`, which
   `zsh/zshrc` exports), it starts one with `zsh -i` and runs itself there. A guard keeps this to one round.
2. **Management subcommands** (`claude mcp …`, `claude plugin …`; list in `zsh/custom/900-aliases`) go straight to
   the real binary with the profile's keys.
3. **The prime-directive corpus** goes into the system prompt as `--append-system-prompt`, built by
   `prime-directive tools initialize` with the flags and ceilings in `zsh/custom/900-aliases` (shared with `omp`). When
   that fails or prints nothing, Claude does not start.
4. **Under the Claude Agent SDK** (`--input-format stream-json`, how T3 Code runs Claude), the SDK's `initialize`
   control request carries its own `appendSystemPrompt`, and Claude Code then drops the command line's. So the corpus
   is also added to that request, after the SDK's own text. Every other input line passes through untouched.

## Using it from T3 Code

T3 Code → **Settings → Providers → Claude → Binary path**: this repository's `bin/claude`, for example
`/home/nerdo/personal/settings/bin/claude` on frankenstein. Set it per environment: T3 runs Claude on the machine the
environment is on, with that machine's copy of this repository.

## Tests

`zsh commands/claude/claude.test.zsh` (also run by `zsh/tests/run`): a fake real `claude` and `prime-directive` on PATH
behind `bin/`, and SecretSpec reading a fixture instead of OpenBao.

Checked end to end on 2026-10-29 through the Agent SDK (`@anthropic-ai/claude-agent-sdk` 0.3.312, preset `claude_code`
with appended text, as T3 Code calls it): the plain binary saw the SDK's text but not the corpus; this command, started
outside an interactive shell, saw both.
