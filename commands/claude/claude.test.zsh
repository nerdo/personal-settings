#!/usr/bin/env zsh
# Tests for the claude command (./claude), run through its bin/ symlinks the way a shell or T3 Code starts it.
# Run: zsh commands/claude/claude.test.zsh

set -u

command_dir="${0:A:h}"
repo_dir="${command_dir:h:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/real"
dump_file="$tmp_dir/child-env"
prompt_file="$tmp_dir/system-prompt"
stdin_file="$tmp_dir/child-stdin"
pd_args_file="$tmp_dir/pd-args"

# A fake real `claude` later on PATH than bin/: it records what the command handed it. Paths are baked into the
# script text, because the environment is what is under test.
cat > "$tmp_dir/real/claude" <<FAKE
#!/usr/bin/env zsh
print -r -- "ARGS: \$*" > "$dump_file"
env >> "$dump_file"
rm -f "$prompt_file"
[[ "\$1" == --append-system-prompt ]] && print -r -- "\$2" > "$prompt_file"
cat > "$stdin_file"
true
FAKE

write_fake_prime_directive() {
  cat > "$tmp_dir/real/prime-directive" <<FAKE
#!/usr/bin/env zsh
print -r -- "\$*" > "$pd_args_file"
$1
FAKE
  chmod +x "$tmp_dir/real/prime-directive"
}
write_fake_prime_directive 'print -r -- "fake corpus"'
chmod +x "$tmp_dir/real/claude"

PATH="$repo_dir/bin:$tmp_dir/real:$PATH"

# SecretSpec reads a fixture instead of OpenBao, holding every name the profiles declare, so no real key is read.
_ss_fixture="$tmp_dir/secretspec-fixture.env"
bun -e "const m = Bun.TOML.parse(await Bun.file('$repo_dir/secretspec/secretspec.toml').text()); for (const n of new Set(Object.values(m.profiles).flatMap(Object.keys))) console.log(n + '=fx-' + n)" > "$_ss_fixture"
export SECRETSPEC_PROVIDER="dotenv:$_ss_fixture"

# Started from Dannel's interactive shell unless a test says otherwise.
export SETTINGS_ZSHRC_LOADED=1
unset LANGFUSE_TRACING_ENVIRONMENT CLAUDE_CONFIG_DIR

child_env_value() {
  local line
  line="$(rg --no-line-number "^${1}=" "$dump_file" 2>/dev/null | head -1)"
  [[ -z "$line" ]] && print -r -- "<unset>" || print -r -- "${line#${1}=}"
}

assert_child_env() {
  local actual
  actual="$(child_env_value "$2")"
  [[ "$actual" == "$3" ]] && pass "$1" || fail "$1" "$2: expected '$3', child received '$actual'"
}

child_args() {
  [[ -e "$dump_file" ]] || { print -r -- "<binary never ran>"; return }
  local first
  first="$(head -1 "$dump_file")"
  print -r -- "${first#ARGS: }"
}

reset_dumps() { rm -f "$dump_file" "$prompt_file" "$stdin_file" "$pd_args_file" }

# --- the command line ----------------------------------------------------------------------------------------------

# bin/ is first on PATH, so the command must look past itself for the real binary, or it starts itself forever.
reset_dumps
timeout 20 claude -p hi </dev/null >/dev/null 2>&1
args="$(child_args)"
[[ "$args" == *" -p hi" ]] && pass "claude starts the real binary, not itself, when bin/ is first on PATH" \
  || fail "claude starts the real binary, not itself, when bin/ is first on PATH" "binary received '$args'"

reset_dumps
claude -p hi </dev/null >/dev/null 2>&1
received="<no system prompt>"; [[ -e "$prompt_file" ]] && received="$(<"$prompt_file")"
[[ "$received" == "fake corpus" ]] && pass "claude hands the real binary the corpus as --append-system-prompt" \
  || fail "claude hands the real binary the corpus as --append-system-prompt" "binary received '$received'"

args="$(child_args)"
[[ "$args" == *" -p hi" ]] && pass "claude passes its own arguments after the system prompt" \
  || fail "claude passes its own arguments after the system prompt" "binary received '$args'"

received="<prime-directive never ran>"; [[ -e "$pd_args_file" ]] && received="$(<"$pd_args_file")"
[[ " $received " == *" --host-max-bytes 25000 "* ]] && pass "claude passes --host-max-bytes 25000 to initialize" \
  || fail "claude passes --host-max-bytes 25000 to initialize" "initialize received '$received'"

assert_child_env "claude runs the binary with the claude profile's LANGFUSE_PUBLIC_KEY" \
  LANGFUSE_PUBLIC_KEY fx-LANGFUSE_PUBLIC_KEY
assert_child_env "claude sets LANGFUSE_TRACING_ENVIRONMENT to claude-code-personal by default" \
  LANGFUSE_TRACING_ENVIRONMENT claude-code-personal
assert_child_env "claude sets CLAUDE_CONFIG_DIR to ~/.claude by default" \
  CLAUDE_CONFIG_DIR "$HOME/.claude"

reset_dumps
LANGFUSE_TRACING_ENVIRONMENT=scratch claude -p hi </dev/null >/dev/null 2>&1
assert_child_env "a caller's LANGFUSE_TRACING_ENVIRONMENT wins over the default" LANGFUSE_TRACING_ENVIRONMENT scratch

reset_dumps
claude mcp list </dev/null >/dev/null 2>&1
args="$(child_args)"
[[ "$args" == "mcp list" ]] && pass "claude given a management subcommand reaches the binary with its arguments untouched" \
  || fail "claude given a management subcommand reaches the binary with its arguments untouched" "binary received '$args'"

reset_dumps
write_fake_prime_directive 'exit 3'
claude -p hi </dev/null >/dev/null 2>&1
claude_status=$?
[[ ! -e "$dump_file" ]] && pass "claude does not start the binary when prime-directive fails" \
  || fail "claude does not start the binary when prime-directive fails" "binary ran with '$(child_args)'"
(( claude_status != 0 )) && pass "claude exits non-zero when prime-directive fails" \
  || fail "claude exits non-zero when prime-directive fails" "exit status $claude_status"
write_fake_prime_directive 'print -r -- "fake corpus"'

# --- driven by the Claude Agent SDK (T3 Code) ----------------------------------------------------------------------

# The SDK sends its own appendSystemPrompt in the initialize control request, and Claude Code then drops the CLI's
# --append-system-prompt. The command adds the corpus to the SDK's text instead.
init_line='{"request_id":"r1","type":"control_request","request":{"subtype":"initialize","appendSystemPrompt":"T3 TEXT","hooks":null}}'
user_line='{"type":"user","message":{"role":"user","content":"hello \"there\" — ünïcode"},"parent_tool_use_id":null}'

reset_dumps
print -r -- "$init_line"$'\n'"$user_line" | claude --input-format stream-json --output-format stream-json >/dev/null 2>&1
received="$(head -1 "$stdin_file" 2>/dev/null | jq -r '.request.appendSystemPrompt' 2>/dev/null)"
[[ "$received" == "T3 TEXT"$'\n\n'"fake corpus" ]] \
  && pass "under the SDK, the initialize request reaches the binary with the corpus after the SDK's own text" \
  || fail "under the SDK, the initialize request reaches the binary with the corpus after the SDK's own text" "binary received '$received'"

received="$(command sed -n 2p "$stdin_file" 2>/dev/null)"
[[ "$received" == "$user_line" ]] && pass "under the SDK, every other input line reaches the binary byte for byte" \
  || fail "under the SDK, every other input line reaches the binary byte for byte" "binary received '$received'"

reset_dumps
print -r -- '{"request_id":"r1","type":"control_request","request":{"subtype":"initialize"}}' \
  | claude --input-format stream-json --output-format stream-json >/dev/null 2>&1
received="$(head -1 "$stdin_file" 2>/dev/null | jq -r '.request.appendSystemPrompt' 2>/dev/null)"
[[ "$received" == "fake corpus" ]] && pass "under the SDK, an initialize request without append text gets the corpus alone" \
  || fail "under the SDK, an initialize request without append text gets the corpus alone" "binary received '$received'"

# --- claude-tsi: the same command under another name ----------------------------------------------------------------

export N8N_API_URL=personal
reset_dumps
claude-tsi -p hi </dev/null >/dev/null 2>&1
assert_child_env "claude-tsi runs the binary with the claude-tsi profile's N8N_API_URL, not the parent shell's" \
  N8N_API_URL fx-N8N_API_URL
assert_child_env "claude-tsi sets LANGFUSE_TRACING_ENVIRONMENT to claude-code-tsi by default" \
  LANGFUSE_TRACING_ENVIRONMENT claude-code-tsi
assert_child_env "claude-tsi sets CLAUDE_CONFIG_DIR to ~/.claude-tsi by default" CLAUDE_CONFIG_DIR "$HOME/.claude-tsi"

# `mcp` is in _PD_CLAUDE_SUBCOMMANDS, so this takes the pass-through branch.
reset_dumps
claude-tsi mcp </dev/null >/dev/null 2>&1
assert_child_env "claude-tsi given a management subcommand gets the profile's N8N_API_URL too" \
  N8N_API_URL fx-N8N_API_URL
unset N8N_API_URL

# --- started outside Dannel's interactive shell (T3 Code's service) ----------------------------------------------------

# Without the interactive shell's marker, the command loads that shell first, so a program that starts it directly
# gets the same environment as a terminal. ZDOTDIR points zsh at a fixture .zshrc.
mkdir -p "$tmp_dir/zdot"
print -r -- 'export SETTINGS_ZSHRC_LOADED=1 FROM_ZSHRC=yes' > "$tmp_dir/zdot/.zshrc"
reset_dumps
env -u SETTINGS_ZSHRC_LOADED ZDOTDIR="$tmp_dir/zdot" "$repo_dir/bin/claude" -p hi </dev/null >/dev/null 2>&1
assert_child_env "started outside the interactive shell, claude runs the binary with that shell's environment" FROM_ZSHRC yes

print -r -- 'export FROM_ZSHRC=no-marker' > "$tmp_dir/zdot/.zshrc"
reset_dumps
env -u SETTINGS_ZSHRC_LOADED ZDOTDIR="$tmp_dir/zdot" timeout 20 "$repo_dir/bin/claude" -p hi </dev/null >/dev/null 2>&1
args="$(child_args)"
[[ "$args" == *" -p hi" ]] && pass "claude starts the binary once even when the shell it loads sets no marker" \
  || fail "claude starts the binary once even when the shell it loads sets no marker" "binary received '$args'"

if (( failures == 0 )); then
  print -r -- "all assertions passed"
  exit 0
fi
print -r -- "$failures assertion(s) failed"
exit 1
