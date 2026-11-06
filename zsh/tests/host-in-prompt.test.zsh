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

login_user=ada

# The prompt as oh-my-posh draws it for a given theme file. env -i because a running oh-my-posh shell exports
# POSH_SESSION_ID, and with it oh-my-posh reads that session's cached config instead of --config.
render() {
  ( cd "$work" && env -i HOME="$work" USER="$login_user" PATH=/usr/bin:/bin TERM=xterm-256color \
    "$posh" print primary --config "$1" --shell zsh )
}

# What a person reads: the prompt without its color codes.
visible_text() { print -r -- "$1" | sed 's/%{[^%]*%}//g' }

assert_prompt_names_this_machine() {
  local statement="the prompt reads user@host, naming the machine it runs on"
  local host; host="$(uname -n)"; host="${host%%.*}"
  local actual; actual="$(visible_text "$(render "$theme")")"

  if [[ "$actual" == *" ada@$host "* ]]; then
    pass "$statement"
  else
    fail "$statement" "expected ada@$host, got: ${(qqq)actual}"
  fi
}

# oh-my-posh takes the host name from the OS, which a test cannot set on both Linux and macOS, so the theme gets a
# literal in its place. assert_prompt_names_this_machine is what proves the theme reads the machine's real name.
last_color_before_host() {
  local host="$1" as_host="$work/as-host.omp.json"
  sed "s/\.HostName/\\\\\"$host\\\\\"/g" "$theme" > "$as_host"
  local prompt; prompt="$(render "$as_host")"
  print -r -- "${prompt%%$host*}" | grep -o "$2;2;[0-9;]*" | tail -n 1
}
host_color() { last_color_before_host "$1" 48 }
host_text_color() { last_color_before_host "$1" 38 }

assert_two_known_machines_differ() {
  local statement="nerdo on relentless and nerdo on frankenstein are drawn on different background colors"
  local login_user=nerdo relentless frankenstein
  relentless="$(host_color relentless)"; frankenstein="$(host_color frankenstein)"

  if [[ -n "$relentless" && "$relentless" != "$frankenstein" ]]; then
    pass "$statement"
  else
    fail "$statement" "relentless: ${(qqq)relentless}, frankenstein: ${(qqq)frankenstein}"
  fi
}

# A machine nobody has named yet: at twenty names, a palette barely used would leave most machines looking alike.
assert_host_names_spread_across_colors() {
  local statement="twenty host names are drawn on at least six different background colors"
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
  local statement="relentless is drawn on one background color across five prompts"
  local i; local -A seen
  for i in {1..5}; do seen[$(host_color relentless)]=1; done

  if (( ${#seen} == 1 )); then
    pass "$statement"
  else
    fail "$statement" "drawn in ${#seen} colors: ${(k)seen}"
  fi
}

# The name has to stand out from the prompt around it. 80 is the distance in RGB between two colors below which they
# read as shades of one color next to each other, as #ff7ad9 does beside the path's #ffafd2. The folder this renders
# in is not a git repo, so the git branch's color is not among the ones compared.
assert_host_color_stands_apart_from_the_prompt() {
  local statement="a host's background is at least 80 (RGB distance) from every other color in the prompt"
  local too_close=() name host_rgb other r1 g1 b1 r2 g2 b2 parts
  local -a others; others=(${(u)${(f)"$(render "$theme" | grep -o '38;2;[0-9;]*' | sed 's/^38;2;//')"}})
  local -A seen
  for name in host{1..60} relentless frankenstein; do seen[$(host_color "$name")]=1; done

  for host_rgb in ${(k)seen}; do
    parts=(${(s:;:)host_rgb#48;2;}); r1=$parts[1]; g1=$parts[2]; b1=$parts[3]
    for other in $others; do
      parts=(${(s:;:)other}); r2=$parts[1]; g2=$parts[2]; b2=$parts[3]
            (( (r1-r2)**2 + (g1-g2)**2 + (b1-b2)**2 < 6400 )) && too_close+=("${host_rgb#48;2;} near $other")
    done
  done

  if (( ${#too_close} == 0 )); then
    pass "$statement"
  else
    fail "$statement" "too close: ${(j:, :)too_close}"
  fi
}

# WCAG 2 relative luminance of one "r;g;b" color.
luminance() {
  local parts=(${(s:;:)1}) channel linear total=0 weights=(0.2126 0.7152 0.0722) i
  for i in 1 2 3; do
    (( channel = parts[i] / 255.0 ))
    if (( channel <= 0.03928 )); then (( linear = channel / 12.92 )); else (( linear = ((channel + 0.055) / 1.055) ** 2.4 )); fi
    (( total += weights[i] * linear ))
  done
  print -r -- "$total"
}

# 4.5:1 is WCAG 2's AA minimum for normal text (https://www.w3.org/TR/WCAG21/#contrast-minimum).
assert_text_is_readable_on_every_background() {
  local statement="user@host has at least 4.5:1 contrast with its background, for every background"
  local name too_low=() bg text l1 l2 ratio
  for name in host{1..60} relentless frankenstein; do
    bg="$(host_color "$name")"; text="$(host_text_color "$name")"
    l1="$(luminance "${bg#48;2;}")"; l2="$(luminance "${text#38;2;}")"
    (( ratio = l1 > l2 ? (l1 + 0.05) / (l2 + 0.05) : (l2 + 0.05) / (l1 + 0.05) ))
    (( ratio < 4.5 )) && too_low+=("${text#38;2;} on ${bg#48;2;}")
  done

  if (( ${#too_low} == 0 )); then
    pass "$statement"
  else
    fail "$statement" "too low: ${(j:, :u)too_low}"
  fi
}

assert_prompt_opens_with_the_user_at_host_block() {
  setopt local_options extended_glob
  local statement="the prompt's first characters, after spaces, are user@host"
  local actual; actual="$(visible_text "$(render "$theme")")"
  actual="${actual%%$'\n'*}"

  if [[ "$actual" == [[:space:]]#ada@* ]]; then
    pass "$statement"
  else
    fail "$statement" "first line: ${(qqq)actual}"
  fi
}

assert_two_logins_on_one_machine_differ() {
  local statement="nerdo and root on relentless are drawn on different background colors"
  local nerdo root
  nerdo="$(login_user=nerdo host_color relentless)"; root="$(login_user=root host_color relentless)"

  if [[ -n "$nerdo" && "$nerdo" != "$root" ]]; then
    pass "$statement"
  else
    fail "$statement" "nerdo: ${(qqq)nerdo}, root: ${(qqq)root}"
  fi
}

assert_prompt_names_this_machine
assert_two_logins_on_one_machine_differ
assert_prompt_opens_with_the_user_at_host_block
assert_text_is_readable_on_every_background
assert_host_color_stands_apart_from_the_prompt
assert_a_machine_keeps_its_color
assert_two_known_machines_differ
assert_host_names_spread_across_colors

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
