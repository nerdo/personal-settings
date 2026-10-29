#!/usr/bin/env zsh
# Tests for ../custom/990-commands: this repo's commands (bin/) win over programs of the same name on PATH.
# Run: zsh zsh/tests/990-commands.test.zsh

set -u

script_dir="${0:A:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# A copy of the module in a fixture repo, beside a bin/ of its own: the module finds bin/ from its own path.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/repo/zsh/custom" "$tmp_dir/repo/bin" "$tmp_dir/elsewhere"
cp "${script_dir:h}/custom/990-commands" "$tmp_dir/repo/zsh/custom/990-commands"
print -r -- $'#!/usr/bin/env zsh\nprint -r -- "repo foo: $*"' > "$tmp_dir/repo/bin/foo"
print -r -- $'#!/usr/bin/env zsh\nprint -r -- "path foo"' > "$tmp_dir/elsewhere/foo"
chmod +x "$tmp_dir/repo/bin/foo" "$tmp_dir/elsewhere/foo"

# What mise, volta and bun do after 010-path: another folder with the same name first on PATH.
PATH="$tmp_dir/elsewhere:$tmp_dir/repo/bin:$PATH"
source "$tmp_dir/repo/zsh/custom/990-commands"

received="$(foo a b 2>&1)"
[[ "$received" == "repo foo: a b" ]] && pass "a command in bin/ runs, with its arguments, even when PATH finds another first" \
  || fail "a command in bin/ runs, with its arguments, even when PATH finds another first" "got '$received'"

if (( failures == 0 )); then print -r -- "all assertions passed"; exit 0; fi
print -r -- "$failures assertion(s) failed"; exit 1
