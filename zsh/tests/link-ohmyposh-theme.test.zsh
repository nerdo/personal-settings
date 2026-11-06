#!/usr/bin/env zsh
# Tests for ../bin/link-ohmyposh-theme: ~/.config/ohmyposh/1_shell.omp.json becomes a link to this repo's theme, so a
# machine that keeps a theme there (relentless: ml4w's folder) follows the repo.
# Run: zsh zsh/tests/link-ohmyposh-theme.test.zsh

set -u

script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
theme="$repo_dir/ohmyposh/1_shell.omp.json"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

new_home() { mktemp -d }
link_theme() { HOME="$1" "$repo_dir/zsh/bin/link-ohmyposh-theme" 2>&1 }

# Where the theme file under this home links to; empty when it is not a link.
resolved_theme() { readlink "$1/.config/ohmyposh/1_shell.omp.json" }

assert_a_machine_with_no_theme_folder_gets_the_link() {
  local statement="with no ~/.config/ohmyposh, the theme there reads this repo's theme"
  local home; home="$(new_home)"
  link_theme "$home" >/dev/null
  local actual; actual="$(resolved_theme "$home")"
  rm -rf "$home"

  if [[ "$actual" == "$theme" ]]; then
    pass "$statement"
  else
    fail "$statement" "resolves to: ${(qqq)actual}"
  fi
}

# relentless's case: ml4w's folder holds a regular file by that name.
home_with_a_theme_file() {
  local home; home="$(new_home)"
  mkdir -p "$home/.config/ohmyposh"
  print -r -- 'the theme ml4w left here' > "$home/.config/ohmyposh/1_shell.omp.json"
  print -r -- "$home"
}

assert_an_existing_theme_is_replaced_by_the_link() {
  local statement="with a theme file already there, the theme there reads this repo's theme"
  local home; home="$(home_with_a_theme_file)"
  link_theme "$home" >/dev/null
  local actual; actual="$(resolved_theme "$home")"
  rm -rf "$home"

  if [[ "$actual" == "$theme" ]]; then
    pass "$statement"
  else
    fail "$statement" "links to: ${(qqq)actual}"
  fi
}

# The file may be the only copy of what a machine customized, so linking keeps it beside the link.
assert_an_existing_theme_is_kept_beside_the_link() {
  local statement="the theme file that was there is kept as 1_shell.omp.json.before-link.* with its contents"
  local home; home="$(home_with_a_theme_file)"
  link_theme "$home" >/dev/null
  local kept=("$home/.config/ohmyposh/1_shell.omp.json.before-link."*(N))
  local actual=""; (( ${#kept} == 1 )) && actual="$(<"$kept[1]")"
  rm -rf "$home"

  if [[ "$actual" == "the theme ml4w left here" ]]; then
    pass "$statement"
  else
    fail "$statement" "kept ${#kept} file(s), contents: ${(qqq)actual}"
  fi
}

# 020-customization looks for 1_shell.toml first, so a link beside one would change nothing on screen.
assert_a_toml_theme_stops_it_and_says_so() {
  local statement="with a 1_shell.toml in the folder, it exits 1 and tells the person to remove that file"
  local home; home="$(new_home)"
  mkdir -p "$home/.config/ohmyposh"
  : > "$home/.config/ohmyposh/1_shell.toml"
  local output code; output="$(link_theme "$home")"; code=$?
  rm -rf "$home"

  if (( code == 1 )) && [[ "$output" == *"Remove"*"1_shell.toml"* ]]; then
    pass "$statement"
  else
    fail "$statement" "exit $code, said: ${(qqq)output}"
  fi
}

assert_a_second_run_changes_nothing() {
  local statement="run a second time, it prints nothing and keeps no second copy"
  local home; home="$(new_home)"
  link_theme "$home" >/dev/null
  local output; output="$(link_theme "$home")"
  local kept=("$home/.config/ohmyposh/1_shell.omp.json.before-link."*(N))
  rm -rf "$home"

  if [[ -z "$output" ]] && (( ${#kept} == 0 )); then
    pass "$statement"
  else
    fail "$statement" "printed ${(qqq)output}, kept ${#kept} file(s)"
  fi
}

# The whole point: a shell started after the link is on this repo's theme. A stub oh-my-posh announces its --config,
# the same way as 020-customization.test.zsh, and the stub oh-my-zsh keeps anything from being cloned.
assert_a_new_shell_starts_on_the_repo_theme() {
  local statement="after linking, a new shell's prompt reads this repo's theme through ~/.config/ohmyposh"
  local home bin; home="$(new_home)"; bin="$home/stub-bin"
  mkdir -p "$home/.oh-my-zsh/custom/plugins/"{zsh-autosuggestions,zsh-syntax-highlighting,fast-syntax-highlighting} "$bin"
  : > "$home/.oh-my-zsh/oh-my-zsh.sh"
  print -r -- '#!/bin/sh
while [ $# -gt 0 ]; do [ "$1" = --config ] && { echo "print -r -- POSH_CONFIG:$2"; exit 0; }; shift; done' > "$bin/oh-my-posh"
  chmod +x "$bin/oh-my-posh"
  link_theme "$home" >/dev/null
  local config; config="$(env -i HOME="$home" ZSH="$home/.oh-my-zsh" PATH="$bin:/usr/bin:/bin" TERM=xterm \
    zsh -f -c "source '$repo_dir/zsh/custom/020-customization'" 2>/dev/null | sed -n 's/^POSH_CONFIG://p')"
  local expected="$home/.config/ohmyposh/1_shell.omp.json"
  local same=no; [[ "$config" == "$expected" && "$config" -ef "$theme" ]] && same=yes
  rm -rf "$home"

  if [[ "$same" == yes ]]; then
    pass "$statement"
  else
    fail "$statement" "started with: ${(qqq)config}"
  fi
}

assert_a_toml_theme_stops_it_and_says_so
assert_a_second_run_changes_nothing
assert_a_new_shell_starts_on_the_repo_theme
assert_a_machine_with_no_theme_folder_gets_the_link
assert_an_existing_theme_is_replaced_by_the_link
assert_an_existing_theme_is_kept_beside_the_link

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
