#!/usr/bin/env zsh
# Tests for the host name in the prompt: real oh-my-posh rendering this repo's ../../ohmyposh/1_shell.omp.json.
# Run: zsh zsh/tests/host-in-prompt.test.zsh

set -u

script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
theme="$repo_dir/ohmyposh/1_shell.omp.json"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

if ! command -v oh-my-posh &>/dev/null; then
  print -r -- "skip - oh-my-posh is not installed (zsh/bin/install-oh-my-posh)"
  exit 0
fi
posh="$(command -v oh-my-posh)"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The prompt as oh-my-posh draws it for a given theme file. env -i because a running oh-my-posh shell exports
# POSH_SESSION_ID, and with it oh-my-posh reads that session's cached config instead of --config.
render() {
  ( cd "$work" && env -i HOME="$work" USER=ada PATH=/usr/bin:/bin TERM=xterm-256color \
    "$posh" print primary --config "$1" --shell zsh )
}

# What a person reads: the prompt without its color codes.
visible_text() { print -r -- "$1" | sed 's/%{[^%]*%}//g' }

assert_prompt_names_this_machine() {
  local statement="the prompt reads user@host, naming the machine it runs on"
  local host; host="$(uname -n)"; host="${host%%.*}"
  local actual; actual="$(visible_text "$(render "$theme")")"

  if [[ "$actual" == *"ada@$host on"* ]]; then
    pass "$statement"
  else
    fail "$statement" "expected ada@$host on, got: ${(qqq)actual}"
  fi
}

# oh-my-posh takes the host name from the OS, which a test cannot set on both Linux and macOS, so the theme gets a
# literal in its place. assert_prompt_names_this_machine is what proves the theme reads the machine's real name.
host_color() {
  local host="$1" as_host="$work/as-host.omp.json"
  sed "s/\.HostName/\\\\\"$host\\\\\"/g" "$theme" > "$as_host"
  local prompt; prompt="$(render "$as_host")"
  print -r -- "${prompt%%$host*}" | grep -o '38;2;[0-9;]*' | tail -n 1
}

assert_two_known_machines_differ() {
  local statement="relentless and frankenstein are drawn in different colors"
  local relentless frankenstein
  relentless="$(host_color relentless)"; frankenstein="$(host_color frankenstein)"

  if [[ -n "$relentless" && "$relentless" != "$frankenstein" ]]; then
    pass "$statement"
  else
    fail "$statement" "relentless: ${(qqq)relentless}, frankenstein: ${(qqq)frankenstein}"
  fi
}

# A machine nobody has named yet: at twenty names, a palette barely used would leave most machines looking alike.
assert_host_names_spread_across_colors() {
  local statement="twenty host names are drawn in at least six different colors"
  local names=(web1 web2 db1 db2 pi nas router laptop desktop mini studio build ci vm1 vm2 prod staging dev gateway media)
  local name; local -A seen
  for name in $names; do seen[$(host_color "$name")]=1; done

  if (( ${#seen} >= 6 )); then
    pass "$statement"
  else
    fail "$statement" "drawn in ${#seen} color(s): ${(k)seen}"
  fi
}

assert_a_machine_keeps_its_color() {
  local statement="relentless is drawn in one color across five prompts"
  local i; local -A seen
  for i in {1..5}; do seen[$(host_color relentless)]=1; done

  if (( ${#seen} == 1 )); then
    pass "$statement"
  else
    fail "$statement" "drawn in ${#seen} colors: ${(k)seen}"
  fi
}

# The name has to stand out from the prompt around it. 80 is the distance in RGB between two colors below which they
# read as shades of one color next to each other, as #ff7ad9 does beside the prompt's #ff70a6. The folder this renders
# in is not a git repo, so the git branch's color is not among the ones compared.
assert_host_color_stands_apart_from_the_prompt() {
  local statement="a host's color is at least 80 (RGB distance) from every other color in the prompt"
  local too_close=() name host_rgb other r1 g1 b1 r2 g2 b2 parts
  local -a others; others=(${(u)${(f)"$(render "$theme" | grep -o '38;2;[0-9;]*' | sed 's/^38;2;//')"}})
  local -A seen
  for name in host{1..60} relentless frankenstein; do seen[$(host_color "$name")]=1; done

  for host_rgb in ${(k)seen}; do
    parts=(${(s:;:)host_rgb#38;2;}); r1=$parts[1]; g1=$parts[2]; b1=$parts[3]
    for other in $others; do
      parts=(${(s:;:)other}); r2=$parts[1]; g2=$parts[2]; b2=$parts[3]
      [[ "${host_rgb#38;2;}" == "$other" ]] && continue
      (( (r1-r2)**2 + (g1-g2)**2 + (b1-b2)**2 < 6400 )) && too_close+=("${host_rgb#38;2;} near $other")
    done
  done

  if (( ${#too_close} == 0 )); then
    pass "$statement"
  else
    fail "$statement" "too close: ${(j:, :)too_close}"
  fi
}

assert_prompt_names_this_machine
assert_host_color_stands_apart_from_the_prompt
assert_a_machine_keeps_its_color
assert_two_known_machines_differ
assert_host_names_spread_across_colors

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
