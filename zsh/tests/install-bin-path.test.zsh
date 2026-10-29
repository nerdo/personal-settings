#!/usr/bin/env zsh
# Tests for ../bin/install-bin-path: this repo's bin/ first on the PATH of programs started outside zsh (Linux: the
# desktop session through uwsm, and systemd user services). Elsewhere (macOS) it writes nothing.
# Run: zsh zsh/tests/install-bin-path.test.zsh

set -u

script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
fake_home="$tmp_dir/home"
mkdir -p "$fake_home"
generator=/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator

install() { HOME="$fake_home" "$repo_dir/zsh/bin/install-bin-path" 2>&1 }
install >/dev/null

if whence -p uwsm >/dev/null; then
  # uwsm sources Omarchy's env.d (mise's shims first), then ~/.config/uwsm/env.d.
  received="$(env -i HOME="$fake_home" PATH="$fake_home/.local/share/mise/shims:/usr/bin:$fake_home/.local/bin" \
    sh -c ". '$fake_home/.config/uwsm/env.d/50-settings-bin-first'; printf '%s' \"\${PATH%%:*}\"" 2>&1)"
  [[ "$received" == "$repo_dir/bin" ]] && pass "the desktop session's PATH starts with this repo's bin/" \
    || fail "the desktop session's PATH starts with this repo's bin/" "first PATH entry is '$received'"
else
  print -r -- "skip - the desktop session's PATH starts with this repo's bin/ (no uwsm here)"
fi

if [[ -x $generator ]]; then
  # User services started before any desktop login: systemd's own generator reads ~/.config/environment.d.
  received="$(env -i HOME="$fake_home" XDG_CONFIG_HOME="$fake_home/.config" PATH=/usr/bin:/bin "$generator" 2>&1 \
    | rg --no-line-number '^PATH=' | head -1)"
  received="${${received#PATH=}%%:*}"
  [[ "$received" == "$repo_dir/bin" ]] && pass "the user services' PATH starts with this repo's bin/" \
    || fail "the user services' PATH starts with this repo's bin/" "first PATH entry is '$received'"
else
  print -r -- "skip - the user services' PATH starts with this repo's bin/ (no systemd here)"
fi

if ! whence -p uwsm >/dev/null && [[ ! -x $generator ]]; then
  received="$(find "$fake_home" -type f 2>/dev/null)"
  [[ -z "$received" ]] && pass "with neither uwsm nor systemd (macOS), install-bin-path writes nothing" \
    || fail "with neither uwsm nor systemd (macOS), install-bin-path writes nothing" "wrote: $received"
fi

received="$(install)"
[[ -z "$received" ]] && pass "install-bin-path run a second time changes nothing" \
  || fail "install-bin-path run a second time changes nothing" "second run printed '$received'"

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
