#!/usr/bin/env zsh
# Tests for the suite runner in ./run.
# Run: zsh zsh/tests/run.test.zsh

set -u

script_dir="${0:A:h}"
runner="$script_dir/run"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# The runner discovers suites in its own directory via ${0:A:h}, so a copy in a
# temp directory sees only the fixtures placed beside it.
run_against_fixture_suite() {
  local body="$1"
  local tmp
  tmp="$(mktemp -d)"
  cp "$runner" "$tmp/run"
  print -r -- "$body" > "$tmp/fixture.test.zsh"

  # `status` is read-only in zsh, so the exit code needs its own name.
  zsh "$tmp/run" >/dev/null 2>&1
  local run_status=$?
  rm -rf "$tmp"
  return $run_status
}

# The gate is the whole point of the script: a failing suite must stop whatever
# runs the runner. This path never executed before it was committed.
assert_gate_fails_on_failing_suite() {
  if run_against_fixture_suite 'exit 1'; then
    fail "the runner exits non-zero when a suite fails" \
      "runner exited 0 despite a failing suite"
  else
    pass "the runner exits non-zero when a suite fails"
  fi
}

assert_gate_fails_on_failing_suite

if (( failures > 0 )); then
  print -r -- ""
  print -r -- "$failures assertion(s) failed"
  exit 1
fi

print -r -- ""
print -r -- "all assertions passed"
