#!/usr/bin/env zsh
# Tests for the command functions in ../custom/900-aliases.
# Run: zsh zsh/tests/900-aliases.test.zsh

set -u

script_dir="${0:A:h}"
custom_dir="${script_dir:h}/custom"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# A fake `claude` and a fake `prime-directive` on PATH give the production
# functions something to reach without invoking the real binaries. The functions
# call `command claude`, which skips shell functions but still searches PATH, so
# the fake is what runs.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/bin"
dump_file="$tmp_dir/child-env"

# The dump path is baked into the script text rather than passed through the
# environment, because the environment is the thing under test.
cat > "$tmp_dir/bin/claude" <<FAKE
#!/usr/bin/env zsh
print -r -- "ARGS: \$*" > "$dump_file"
env >> "$dump_file"
FAKE

cat > "$tmp_dir/bin/prime-directive" <<'FAKE'
#!/usr/bin/env zsh
print -r -- "fake corpus"
FAKE

chmod +x "$tmp_dir/bin/claude" "$tmp_dir/bin/prime-directive"
PATH="$tmp_dir/bin:$PATH"

# Source the production file. Nothing here re-declares the functions: the file
# under test is the only definition, so a change to it is what these see.
source "$custom_dir/900-aliases"

# Reads one variable out of the environment the fake binary was invoked with.
# Reports the value it found, so a failure names what the path produced rather
# than only that the expected value was absent.
child_env_value() {
  local name="$1"
  local line
  line="$(rg --no-line-number "^${name}=" "$dump_file" 2>/dev/null | head -1)"
  if [[ -z "$line" ]]; then
    print -r -- "<unset>"
  else
    print -r -- "${line#${name}=}"
  fi
}

assert_child_env() {
  local label="$1"
  local name="$2"
  local expected="$3"
  local actual
  actual="$(child_env_value "$name")"

  if [[ "$actual" == "$expected" ]]; then
    pass "$label"
  else
    fail "$label" "$name: expected '$expected', child received '$actual'"
  fi
}

# --- hermetic environment ----------------------------------------------------

# The suite runs in a developer's own shell, where 100-secrets has already
# exported the real TSI_ values. The mapping under test enumerates exactly those
# names, so a failing assertion would print live API keys to the terminal.
# Everything below must see only its own fixtures.
assert_no_real_tsi_vars() {
  local -a leftover
  leftover=(${(ko)parameters[(I)TSI_*]})

  if (( ${#leftover} == 0 )); then
    pass "the suite sees no TSI_ variables beyond its own fixtures"
  else
    # Names only. Printing the values here is the leak this guards against.
    fail "the suite sees no TSI_ variables beyond its own fixtures" \
      "inherited from the real environment: ${leftover[*]}"
  fi
}

for _real in ${(ko)parameters[(I)TSI_*]}; do
  unset "$_real"
done
unset _real

assert_no_real_tsi_vars

# --- walking skeleton: the mapping reaches the binary at all -----------------

export TSI_SKELETON=wired
claude-tsi >/dev/null 2>&1
assert_child_env "claude-tsi carries a mapped assignment through to the binary" \
  SKELETON wired

# --- the mapping itself ------------------------------------------------------

# Reports the whole emitted list on failure, so a miss names what the function
# produced instead of only that the expected entry was absent.
assert_emits() {
  local label="$1"
  local expected="$2"
  _tsi_env_overrides

  if (( ${_TSI_ENV_OVERRIDES[(I)$expected]} )); then
    pass "$label"
  else
    fail "$label" "expected '$expected'; emitted: ${_TSI_ENV_OVERRIDES[*]:-<nothing>}"
  fi
}

assert_omits() {
  local label="$1"
  local unwanted="$2"
  _tsi_env_overrides

  if (( ${_TSI_ENV_OVERRIDES[(I)$unwanted]} )); then
    fail "$label" "emitted '$unwanted'; full list: ${_TSI_ENV_OVERRIDES[*]}"
  else
    pass "$label"
  fi
}

export TSI_ALPHA=one
assert_emits "an exported TSI_-prefixed variable produces an unprefixed assignment carrying its value" \
  "ALPHA=one"

export PLAIN=nope
assert_omits "a variable without the TSI_ prefix produces no assignment" \
  "PLAIN=nope"

# A plain shell variable, never exported. Without a type check it would leak
# into the child alongside the real secrets.
TSI_LOCAL=notexported
assert_omits "a TSI_-prefixed variable that is not exported produces no assignment" \
  "LOCAL=notexported"

# --- what the -tsi command hands to the binary -------------------------------

assert_child_args() {
  local label="$1"
  local expected="$2"
  local actual
  actual="$(head -1 "$dump_file")"
  actual="${actual#ARGS: }"

  if [[ "$actual" == "$expected" ]]; then
    pass "$label"
  else
    fail "$label" "expected args '$expected', binary received '$actual'"
  fi
}

# Both halves are exported, exactly as 100-secrets leaves them in a real shell.
export N8N_API_URL=personal
export TSI_N8N_API_URL=work

claude-tsi >/dev/null 2>&1
assert_child_env "claude-tsi runs the binary with the unprefixed name holding the TSI_ value" \
  N8N_API_URL work
assert_child_env "claude-tsi leaves the TSI_-prefixed name visible to the binary" \
  TSI_N8N_API_URL work

# `mcp` is in _PD_CLAUDE_SUBCOMMANDS, so this takes the pass-through branch.
claude-tsi mcp >/dev/null 2>&1
assert_child_env "claude-tsi given a management subcommand runs the binary with the mapped value too" \
  N8N_API_URL work
assert_child_args "claude-tsi given a management subcommand reaches the binary without a baked system prompt" \
  "mcp"

if (( failures > 0 )); then
  print -r -- ""
  print -r -- "$failures assertion(s) failed"
  exit 1
fi

print -r -- ""
print -r -- "all assertions passed"
