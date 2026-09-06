#!/usr/bin/env zsh
# Tests for the secrets export in ./100-secrets.
# Run: zsh zsh/tests/100-secrets.test.zsh

set -u

script_dir="${0:A:h}"
custom_dir="${script_dir:h}/custom"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# The module reads ~/.secrets/export, and `~` expands from $HOME at run time, so
# each case gets a throwaway HOME instead of the real secrets directory. It runs
# in a subshell too: an export leaking into this shell would let a later
# assertion pass on a value the module under test never set.
secrets_export() {
  local fixture_home="$1" var_name="$2"
  (
    HOME="$fixture_home"
    source "$custom_dir/100-secrets"
    print -r -- "${(P)var_name:-<unset>}"
  )
}

new_fixture_home() {
  local fixture_home
  fixture_home="$(mktemp -d)"
  mkdir -p "$fixture_home/.secrets/export"
  print -r -- "$fixture_home"
}

# The filename is the contract: it becomes the variable name, contents the value.
assert_file_becomes_env_var() {
  local fixture_home; fixture_home="$(new_fixture_home)"
  print -rn -- "ghp_fixture_value" > "$fixture_home/.secrets/export/FIXTURE_TOKEN"

  local actual; actual="$(secrets_export "$fixture_home" FIXTURE_TOKEN)"
  rm -rf "$fixture_home"

  if [[ "$actual" == "ghp_fixture_value" ]]; then
    pass "a file in export/ becomes an env var named after it"
  else
    fail "a file in export/ becomes an env var named after it" "got: $actual"
  fi
}

# Secrets are written by editors and by `print >`, both of which leave a trailing
# newline. A newline inside a bearer token makes every request using it fail.
assert_trailing_newline_is_stripped() {
  local fixture_home; fixture_home="$(new_fixture_home)"
  print -r -- "ghp_fixture_value" > "$fixture_home/.secrets/export/FIXTURE_TOKEN"

  local actual; actual="$(secrets_export "$fixture_home" FIXTURE_TOKEN)"
  rm -rf "$fixture_home"

  if [[ "$actual" == "ghp_fixture_value" ]]; then
    pass "a trailing newline is stripped from the value"
  else
    fail "a trailing newline is stripped from the value" "got: ${(qqq)actual}"
  fi
}

# export/ is for variables; the rest of ~/.secrets is for on-demand access by
# other apps. A directory there must not turn into an env var holding nothing.
assert_directories_are_skipped() {
  local fixture_home; fixture_home="$(new_fixture_home)"
  mkdir -p "$fixture_home/.secrets/export/FIXTURE_DIR"

  local actual; actual="$(secrets_export "$fixture_home" FIXTURE_DIR)"
  rm -rf "$fixture_home"

  if [[ "$actual" == "<unset>" ]]; then
    pass "a directory in export/ is not exported"
  else
    fail "a directory in export/ is not exported" "got: ${(qqq)actual}"
  fi
}

# The module is sourced from ~/.zshenv, so it runs in every shell on every
# machine — including ones with no ~/.secrets at all. Erroring there would print
# noise into each new shell.
assert_missing_export_dir_is_a_no_op() {
  local fixture_home; fixture_home="$(mktemp -d)"

  local output exit_status
  output="$(secrets_export "$fixture_home" FIXTURE_TOKEN 2>&1)"
  exit_status=$?
  rm -rf "$fixture_home"

  if (( exit_status == 0 )) && [[ "$output" == "<unset>" ]]; then
    pass "a missing ~/.secrets/export is a silent no-op"
  else
    fail "a missing ~/.secrets/export is a silent no-op" "exit $exit_status: $output"
  fi
}

assert_file_becomes_env_var
assert_trailing_newline_is_stripped
assert_directories_are_skipped
assert_missing_export_dir_is_a_no_op

if (( failures > 0 )); then
  print -r -- ""
  print -r -- "$failures assertion(s) failed"
  exit 1
fi

print -r -- ""
print -r -- "all assertions passed"
