#!/usr/bin/env zsh
# Tests for the startup anchor in ./zshenv.
# Run: zsh zsh/tests/zshenv.test.zsh

set -u

script_dir="${0:A:h}"
repo_zsh_dir="${script_dir:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# ml4w owns ~/.zshrc and ~/.config/zshrc — both symlink into ~/.mydotfiles, so an
# update reverts the loader and takes the ~/.config/zshrc/custom symlink with it.
# ~/.zshenv is the one startup file ml4w does not ship. Every case below drives
# the file the way zsh does: through a symlink at $HOME/.zshenv, in an
# environment stripped by `env -i`, with no ~/.config anywhere in the fixture
# home. Whatever works here works after an ml4w update.
#
# zshenv resolves its repo from its own path, so the fixture gets a repo of its
# own — a real copy of zshenv beside a stub zshrc. Letting the fixture link
# ~/.zshrc to the real loader would run the real custom/ modules, and
# 020-customization clones oh-my-zsh into whatever $HOME it finds.
new_fixture() {
  local root; root="$(mktemp -d)"
  mkdir -p "$root/repo/custom" "$root/home"
  cp "$repo_zsh_dir/zshenv" "$root/repo/zshenv"
  cp "$repo_zsh_dir/custom/100-secrets" "$root/repo/custom/100-secrets"
  print -r -- 'print -r -- REPO_LOADER_RAN' > "$root/repo/zshrc"
  ln -s "$root/repo/zshenv" "$root/home/.zshenv"
  print -r -- "$root"
}

with_secret() {
  local root="$1"
  mkdir -p "$root/home/.secrets/export"
  print -rn -- "ghp_fixture_value" > "$root/home/.secrets/export/FIXTURE_TOKEN"
}

# ml4w's loader, as it looks after an update has reverted ~/.zshrc to it.
with_ml4w_zshrc() {
  local root="$1"
  print -r -- 'print -r -- ML4W_LOADER_RAN' > "$root/home/.zshrc.ml4w"
  ln -sfn "$root/home/.zshrc.ml4w" "$root/home/.zshrc"
}

run_zsh() {
  local root="$1"; shift
  env -i HOME="$root/home" PATH="$PATH" TERM=xterm zsh "$@"
}

# The symptom that started this: a token missing from the environment.
# Non-interactive is the harder case and the one ~/.zshrc never covered —
# scripts, editors, and tools spawned outside a login shell all land here.
assert_non_interactive_shell_gets_the_secret() {
  local root; root="$(new_fixture)"; with_secret "$root"

  local actual
  actual="$(run_zsh "$root" -c 'print -r -- ${FIXTURE_TOKEN:-<unset>}' 2>/dev/null)"
  rm -rf "$root"

  if [[ "$actual" == "ghp_fixture_value" ]]; then
    pass "a non-interactive shell gets the secret"
  else
    fail "a non-interactive shell gets the secret" "got: ${(qqq)actual}"
  fi
}

# zsh reads .zshenv before .zshrc, so the interactive shell the user types in
# must see the secret too.
assert_interactive_shell_gets_the_secret() {
  local root; root="$(new_fixture)"; with_secret "$root"

  local actual
  actual="$(run_zsh "$root" -i -c 'print -r -- ${FIXTURE_TOKEN:-<unset>}' 2>/dev/null | tail -1)"
  rm -rf "$root"

  if [[ "$actual" == "ghp_fixture_value" ]]; then
    pass "an interactive shell gets the secret"
  else
    fail "an interactive shell gets the secret" "got: ${(qqq)actual}"
  fi
}

# .zshenv runs for every zsh invocation on every machine, so a home without
# ~/.secrets must start silently. Output here corrupts the stdout of any script
# that shells out to zsh.
assert_home_without_secrets_starts_silently() {
  local root; root="$(new_fixture)"

  local output
  output="$(run_zsh "$root" -c 'true' 2>/dev/null)"
  rm -rf "$root"

  if [[ -z "$output" ]]; then
    pass "a home without ~/.secrets starts silently"
  else
    fail "a home without ~/.secrets starts silently" "got: ${(qqq)output}"
  fi
}

# The point of the anchor: an update has just pointed ~/.zshrc back at ml4w's
# loader, and the next shell repairs itself. .zshenv is read before .zshrc, so
# the repair lands in time for this shell, not the one after it.
assert_ml4w_zshrc_is_repaired_in_the_same_shell() {
  local root; root="$(new_fixture)"; with_ml4w_zshrc "$root"

  local output
  output="$(run_zsh "$root" -i -c 'true' 2>/dev/null)"
  local zshrc_link="$root/home/.zshrc"
  local resolved="${zshrc_link:A}"
  rm -rf "$root"

  if [[ "$output" == *REPO_LOADER_RAN* && "$output" != *ML4W_LOADER_RAN* ]]; then
    pass "an ml4w-owned ~/.zshrc is repaired in the same shell"
  else
    fail "an ml4w-owned ~/.zshrc is repaired in the same shell" "got: ${(qqq)output}"
  fi

  if [[ "$resolved" == "$root/repo/zshrc" ]]; then
    pass "the repaired ~/.zshrc points at the repo loader"
  else
    fail "the repaired ~/.zshrc points at the repo loader" "got: $resolved"
  fi
}

# A fresh machine has no ~/.zshrc at all. Linking only ~/.zshenv has to be enough
# to bootstrap the rest, or the setup instructions grow a second step that an
# ml4w update then breaks.
assert_missing_zshrc_is_created() {
  local root; root="$(new_fixture)"

  local output
  output="$(run_zsh "$root" -i -c 'true' 2>/dev/null)"
  rm -rf "$root"

  if [[ "$output" == *REPO_LOADER_RAN* ]]; then
    pass "a missing ~/.zshrc is created"
  else
    fail "a missing ~/.zshrc is created" "got: ${(qqq)output}"
  fi
}

# The repair runs in every shell, so the steady state has to be a no-op. A link
# rewritten on each startup would churn the mtime and mask a real change.
assert_repair_is_a_no_op_when_already_linked() {
  local root; root="$(new_fixture)"
  ln -sfn "$root/repo/zshrc" "$root/home/.zshrc"
  # GNU stat reports the symlink's own mtime; it does not follow without -L.
  local before; before="$(stat -c %Y "$root/home/.zshrc")"

  run_zsh "$root" -i -c 'true' >/dev/null 2>&1
  local after; after="$(stat -c %Y "$root/home/.zshrc")"
  rm -rf "$root"

  if [[ "$before" == "$after" ]]; then
    pass "the repair does not rewrite an already-correct link"
  else
    fail "the repair does not rewrite an already-correct link" "mtime $before -> $after"
  fi
}

# Rewriting ~/.zshrc from a startup file is a strong move, so there has to be a
# way to run ml4w's loader as shipped — to reproduce a bug, or to bisect one.
assert_self_heal_can_be_opted_out() {
  local root; root="$(new_fixture)"; with_ml4w_zshrc "$root"

  local output
  output="$(env -i HOME="$root/home" PATH="$PATH" TERM=xterm ZSHRC_NO_SELF_HEAL=1 \
    zsh -i -c 'true' 2>/dev/null)"
  rm -rf "$root"

  if [[ "$output" == *ML4W_LOADER_RAN* && "$output" != *REPO_LOADER_RAN* ]]; then
    pass "ZSHRC_NO_SELF_HEAL leaves ml4w's loader in place"
  else
    fail "ZSHRC_NO_SELF_HEAL leaves ml4w's loader in place" "got: ${(qqq)output}"
  fi
}

assert_non_interactive_shell_gets_the_secret
assert_interactive_shell_gets_the_secret
assert_home_without_secrets_starts_silently
assert_ml4w_zshrc_is_repaired_in_the_same_shell
assert_missing_zshrc_is_created
assert_repair_is_a_no_op_when_already_linked
assert_self_heal_can_be_opted_out

if (( failures > 0 )); then
  print -r -- ""
  print -r -- "$failures assertion(s) failed"
  exit 1
fi

print -r -- ""
print -r -- "all assertions passed"
