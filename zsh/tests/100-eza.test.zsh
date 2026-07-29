#!/usr/bin/env zsh
# Tests for the eza aliases in ./100-eza.
# Run: zsh zsh/custom/100-eza.test.zsh

set -u

script_dir="${0:A:h}"
failures=0

# zshrc sources every file in custom/ regardless of extension, so a test file
# living there would execute on every shell startup.
if [[ "${script_dir:t}" == "custom" ]]; then
  custom_dir="$script_dir"
else
  custom_dir="${script_dir:h}/custom"
fi

pass() { print "ok   - $1" }
fail() { print "FAIL - $1"; print "       $2"; (( failures++ )) }

# Source the production aliases. Nothing here re-declares them: the file under
# test is the only definition, so a change to it is what these assertions see.
source "$custom_dir/100-eza"

# custom/ is a load path, not a test path. A test file placed there is sourced
# at every shell startup, printing its output into the user's session.
assert_no_tests_in_custom_dir() {
  local stray
  stray=("$custom_dir"/*.test.*(N) "$custom_dir"/*test.zsh(N))

  if (( ${#stray} == 0 )); then
    pass "custom/ holds no test files"
  else
    fail "custom/ holds no test files" "sourced at startup: ${stray[*]:t}"
  fi
}

# Aliases expand at parse time, so each assertion goes through `eval` to get the
# same expansion an interactive shell performs when the line is typed.
assert_accepts_path() {
  local alias_name="$1"
  local target="$2"
  local output
  local exit_status

  output="$(eval "$alias_name \"$target\"" 2>&1)"
  exit_status=$?

  if (( exit_status == 0 )); then
    pass "$alias_name accepts a path argument"
  else
    fail "$alias_name accepts a path argument" "exit $exit_status: $output"
  fi
}

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/src"
: > "$tmp_dir/src/file.txt"

cd "$tmp_dir"

assert_accepts_path ls src
assert_accepts_path l src
assert_no_tests_in_custom_dir

if (( failures > 0 )); then
  print "\n$failures assertion(s) failed"
  exit 1
fi

print "\nall assertions passed"
