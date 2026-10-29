#!/usr/bin/env zsh
# Tests for ../bin/link-local-bin: this repo's commands in ~/.local/bin, and the PATH files that put ~/.local/bin
# ahead of mise's shims for programs started outside zsh.
# Run: zsh zsh/tests/link-local-bin.test.zsh

set -u

script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
fake_home="$tmp_dir/home"
mkdir -p "$fake_home/.local/bin"

# What ~/.local/bin held before: a mise launcher where bin/gh will go.
print -r -- "mise launcher" > "$fake_home/.local/bin/gh"

link() { HOME="$fake_home" "$repo_dir/zsh/bin/link-local-bin" 2>&1 }
link >/dev/null

received="$(readlink "$fake_home/.local/bin/claude" 2>/dev/null || print -r -- "<no link>")"
[[ "$received" == "$repo_dir/bin/claude" ]] && pass "link-local-bin links ~/.local/bin/claude to this repo's bin/claude" \
  || fail "link-local-bin links ~/.local/bin/claude to this repo's bin/claude" "points to '$received'"

backups=("$fake_home"/.local/share/settings/local-bin-backup/*/gh(N))
received="<no backup>"; (( ${#backups} )) && received="$(<"${backups[1]}")"
[[ "$received" == "mise launcher" ]] && pass "link-local-bin moves a file already in ~/.local/bin to the backup folder" \
  || fail "link-local-bin moves a file already in ~/.local/bin to the backup folder" "backup holds '$received'"

received="$(link)"
[[ -z "$received" ]] && pass "link-local-bin run a second time changes nothing" \
  || fail "link-local-bin run a second time changes nothing" "second run printed '$received'"

received="$(readlink "$fake_home/.config/uwsm/env.d/50-local-bin-first" 2>/dev/null || print -r -- "<no link>")"
[[ "$received" == "$repo_dir/uwsm/env.d/50-local-bin-first" ]] \
  && pass "link-local-bin links the desktop session's PATH file into ~/.config/uwsm/env.d" \
  || fail "link-local-bin links the desktop session's PATH file into ~/.config/uwsm/env.d" "points to '$received'"

received="$(readlink "$fake_home/.config/environment.d/50-local-bin-first.conf" 2>/dev/null || print -r -- "<no link>")"
[[ "$received" == "$repo_dir/systemd/environment.d/50-local-bin-first.conf" ]] \
  && pass "link-local-bin links the user services' PATH file into ~/.config/environment.d" \
  || fail "link-local-bin links the user services' PATH file into ~/.config/environment.d" "points to '$received'"

# The desktop session: uwsm sources Omarchy's env.d (mise's shims first), then ~/.config/uwsm/env.d.
received="$(env -i HOME="$fake_home" PATH="$fake_home/.local/share/mise/shims:/usr/bin:$fake_home/.local/bin" \
  sh -c ". '$repo_dir/uwsm/env.d/50-local-bin-first'; printf '%s' \"\${PATH%%:*}\"" 2>&1)"
[[ "$received" == "$fake_home/.local/bin" ]] && pass "the desktop session's PATH file puts ~/.local/bin first" \
  || fail "the desktop session's PATH file puts ~/.local/bin first" "first PATH entry is '$received'"

# User services started before any desktop login: systemd's own generator reads ~/.config/environment.d.
generator=/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator
if [[ -x $generator ]]; then
  mkdir -p "$tmp_dir/xdg/environment.d"
  ln -s "$repo_dir/systemd/environment.d/50-local-bin-first.conf" "$tmp_dir/xdg/environment.d/"
  received="$(env -i HOME="$fake_home" XDG_CONFIG_HOME="$tmp_dir/xdg" PATH=/usr/bin:/bin "$generator" 2>&1 \
    | rg --no-line-number '^PATH=' | head -1)"
  received="${${received#PATH=}%%:*}"
  [[ "$received" == "$fake_home/.local/bin" ]] && pass "the user services' PATH file puts ~/.local/bin first" \
    || fail "the user services' PATH file puts ~/.local/bin first" "first PATH entry is '$received'"
else
  print -r -- "skip - the user services' PATH file puts ~/.local/bin first (no systemd generator here)"
fi

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
