#!/usr/bin/env zsh
# Tests for the prompt section of ../custom/020-customization: which oh-my-posh theme file the shell starts with.
# Run: zsh zsh/tests/020-customization.test.zsh

set -u

script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
module="$repo_dir/zsh/custom/020-customization"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# A throwaway home with a stub oh-my-zsh (so nothing is cloned) and a stub bin/ holding:
#   oh-my-posh  prints shell code that announces the --config it was started with, as the real init's output is eval'd;
#   curl, wget  record that they ran.
new_fixture() {
  local root; root="$(mktemp -d)"
  mkdir -p "$root/home/.oh-my-zsh/custom/plugins/"{zsh-autosuggestions,zsh-syntax-highlighting,fast-syntax-highlighting} \
    "$root/bin"
  : > "$root/home/.oh-my-zsh/oh-my-zsh.sh"
  print -r -- '#!/bin/sh
while [ $# -gt 0 ]; do [ "$1" = --config ] && { echo "print -r -- POSH_CONFIG:$2"; exit 0; }; shift; done' \
    > "$root/bin/oh-my-posh"
  print -r -- "#!/bin/sh
echo \"\$0\" >> '$root/downloads'" > "$root/bin/curl"
  cp "$root/bin/curl" "$root/bin/wget"
  chmod +x "$root/bin/"*
  print -r -- "$root"
}

# The --config oh-my-posh was started with; empty when it was not started.
posh_config() {
  local root="$1"
  env -i HOME="$root/home" ZSH="$root/home/.oh-my-zsh" PATH="$root/bin:/usr/bin:/bin" TERM=xterm \
    zsh -f -c "source '$module'" 2>/dev/null | sed -n 's/^POSH_CONFIG://p'
}

# frankenstein's case: oh-my-posh installed, no ~/.config/ohmyposh, no system themes folder.
assert_repo_theme_is_used_without_a_local_one() {
  local root; root="$(new_fixture)"
  local actual; actual="$(posh_config "$root")"
  rm -rf "$root"

  if [[ "$actual" == "$repo_dir/ohmyposh/1_shell.omp.json" ]]; then
    pass "with no theme in ~/.config/ohmyposh or a system themes folder, the prompt uses this repo's 1_shell theme"
  else
    fail "with no theme in ~/.config/ohmyposh or a system themes folder, the prompt uses this repo's 1_shell theme" \
      "got: ${(qqq)actual}"
  fi
}

# A theme fetched from a moving branch at shell start is a prompt nobody chose, and oh-my-posh themes can run commands.
assert_nothing_is_downloaded_without_a_local_theme() {
  local root; root="$(new_fixture)"
  posh_config "$root" >/dev/null
  local actual=""; [[ -f "$root/downloads" ]] && actual="$(<"$root/downloads")"
  rm -rf "$root"

  if [[ -z "$actual" ]]; then
    pass "with no theme in ~/.config/ohmyposh, the shell downloads nothing"
  else
    fail "with no theme in ~/.config/ohmyposh, the shell downloads nothing" "ran: ${(qqq)actual}"
  fi
}

# relentless's case: ml4w links ~/.config/ohmyposh to its own folder, and that machine keeps the theme in it.
assert_local_theme_wins_over_the_repo_copy() {
  local root; root="$(new_fixture)"
  mkdir -p "$root/home/.config/ohmyposh"
  print -r -- '{}' > "$root/home/.config/ohmyposh/1_shell.omp.json"
  local actual; actual="$(posh_config "$root")"
  local expected="$root/home/.config/ohmyposh/1_shell.omp.json"
  rm -rf "$root"

  if [[ "$actual" == "$expected" ]]; then
    pass "a theme in ~/.config/ohmyposh wins over this repo's copy"
  else
    fail "a theme in ~/.config/ohmyposh wins over this repo's copy" "got: ${(qqq)actual}"
  fi
}

assert_repo_theme_is_used_without_a_local_one
assert_nothing_is_downloaded_without_a_local_theme
assert_local_theme_wins_over_the_repo_copy

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
