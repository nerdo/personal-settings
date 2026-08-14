#!/usr/bin/env zsh
# Tests for the copy-mode copy bindings in ../keys.conf.
# Run: zsh tmux/tests/copy-mode.test.zsh
#
# Every case drives a scratch tmux server started from this repo's real
# tmux.conf, on its own socket, so the assertions read the bindings this repo
# actually ships and no running tmux session is touched.

set -u

tests_dir="${0:A:h}"
tmux_conf="${tests_dir:h}/tmux.conf"
socket="copy-mode-test-$$"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

tmx() { command tmux -L "$socket" "$@" }

cleanup() { tmx kill-server 2>/dev/null }
trap cleanup EXIT INT TERM

# The pane holds more lines than the window is tall, so copy mode has scrollback
# to sit in and the copied text is identifiable. The pane runs sh directly rather
# than a login shell, so the content does not depend on anyone's shell startup.
start_pane() {
  tmx kill-server 2>/dev/null
  tmx -f "$tmux_conf" new-session -d -s copytest -x 80 -y 10 \
    'sh -c "printf COPYME%02d\\\\n \$(seq 1 60); sleep 600"'
  sleep 0.6
}

discard_buffers() {
  local name
  for name in ${(f)"$(tmx list-buffers -F '#{buffer_name}' 2>/dev/null)"}; do
    tmx delete-buffer -b "$name" 2>/dev/null
  done
}

# Puts the cursor at the start of a scrolled-back line, so a selection taken from
# here has a COPYME word to take.
enter_copy_mode_on_a_word() {
  tmx copy-mode -t copytest
  tmx send-keys -t copytest Up Up Up
  tmx send-keys -t copytest 0
  sleep 0.2
}

# Runs one copy path and records what it left behind.
# Usage: run_copy_case <copy-key> [<selection-key>...]
# Leaves CASE_IN_MODE and CASE_BUFFER set for the assertions below.
run_copy_case() {
  local copy_key="$1"; shift
  local selection_keys=("$@")

  start_pane
  discard_buffers
  enter_copy_mode_on_a_word
  if (( ${#selection_keys} > 0 )); then
    tmx send-keys -t copytest "${selection_keys[@]}"
    sleep 0.2
  fi
  tmx send-keys -t copytest "$copy_key"
  sleep 0.5

  CASE_IN_MODE=$(tmx display -p -t copytest '#{pane_in_mode}' 2>/dev/null)
  CASE_BUFFER=$(tmx show-buffer 2>/dev/null)
}

assert_stays_in_copy_mode() {
  local label="$1"
  if [[ "$CASE_IN_MODE" == 1 ]]; then
    pass "$label leaves the pane in copy mode"
  else
    fail "$label leaves the pane in copy mode" \
      "pane_in_mode is '$CASE_IN_MODE', expected '1'"
  fi
}

assert_copied_the_selection() {
  local label="$1"
  if [[ "$CASE_BUFFER" == *COPYME* ]]; then
    pass "$label puts the selected text in the tmux buffer"
  else
    fail "$label puts the selected text in the tmux buffer" \
      "buffer holds '$CASE_BUFFER', expected text containing 'COPYME'"
  fi
}

# `v e` makes a visual selection over the word the cursor sits on; the click
# bindings make their own selection, so they take no selection keys.
check_copy_path() {
  local label="$1" copy_key="$2"; shift 2
  run_copy_case "$copy_key" "$@"
  assert_stays_in_copy_mode "$label"
  assert_copied_the_selection "$label"
}

check_copy_path "releasing a mouse drag" MouseDragEnd1Pane v e
check_copy_path "double-clicking a word" DoubleClick1Pane
check_copy_path "triple-clicking a line" TripleClick1Pane
check_copy_path "pressing Enter"          Enter            v e
check_copy_path "pressing Ctrl-j"         C-j              v e
check_copy_path "pressing y"              y                v e

if (( failures > 0 )); then
  print -r -- ""
  print -r -- "$failures assertion(s) failed"
  exit 1
fi

print -r -- ""
print -r -- "all assertions passed"
