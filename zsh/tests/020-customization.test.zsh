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
#   oh-my-posh  prints shell code that announces the --config it was started with and that file's first line at that
#               moment, as the real init's output is eval'd;
#   curl, wget  record that they ran.
new_fixture() {
  local root; root="$(mktemp -d)"
  mkdir -p "$root/home/.oh-my-zsh/custom/plugins/"{zsh-autosuggestions,zsh-syntax-highlighting,fast-syntax-highlighting} \
    "$root/bin"
  : > "$root/home/.oh-my-zsh/oh-my-zsh.sh"
  print -r -- '#!/bin/sh
while [ $# -gt 0 ]; do [ "$1" = --config ] && { echo "print -r -- POSH_CONFIG:$2"; echo "print -r -- POSH_READ:$(head -n 1 "$2")"; exit 0; }; shift; done' \
    > "$root/bin/oh-my-posh"
  print -r -- "#!/bin/sh
echo \"\$0\" >> '$root/downloads'" > "$root/bin/curl"
  cp "$root/bin/curl" "$root/bin/wget"
  chmod +x "$root/bin/"*
  print -r -- "$root"
}

# The --config oh-my-posh was started with; empty when it was not started.
posh_config() {
  local root="$1"; shift
  env -i HOME="$root/home" ZSH="$root/home/.oh-my-zsh" PATH="$root/bin:/usr/bin:/bin" TERM=xterm "$@" \
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

# relentless's case: ml4w links ~/.config/ohmyposh to its own folder, and an ml4w update leaves a regular theme in it.
fixture_with_ml4w_theme() {
  local root; root="$(new_fixture)"
  mkdir -p "$root/home/.mydotfiles/ohmyposh" "$root/home/.config"
  print -r -- 'the theme ml4w left here' > "$root/home/.mydotfiles/ohmyposh/1_shell.omp.json"
  ln -s "$root/home/.mydotfiles/ohmyposh" "$root/home/.config/ohmyposh"
  print -r -- "$root"
}

assert_ml4w_theme_becomes_a_link_to_the_repo_theme() {
  local statement="a new shell turns a regular theme in ml4w's folder into a link to this repo's theme"
  local root; root="$(fixture_with_ml4w_theme)"
  posh_config "$root" >/dev/null
  local actual; actual="$(readlink "$root/home/.config/ohmyposh/1_shell.omp.json")"
  rm -rf "$root"

  if [[ "$actual" == "$repo_dir/ohmyposh/1_shell.omp.json" ]]; then
    pass "$statement"
  else
    fail "$statement" "links to: ${(qqq)actual}"
  fi
}

# The shell that notices the file is the one that gets the repo's theme, so there is no second shell to open.
assert_the_shell_that_repairs_starts_on_the_repo_theme() {
  local statement="the shell that repairs the theme starts on this repo's theme"
  local root; root="$(fixture_with_ml4w_theme)"
  local actual; actual="$(env -i HOME="$root/home" ZSH="$root/home/.oh-my-zsh" PATH="$root/bin:/usr/bin:/bin" TERM=xterm \
    zsh -f -c "source '$module'" 2>/dev/null | sed -n 's/^POSH_READ://p')"
  local expected; expected="$(head -n 1 "$repo_dir/ohmyposh/1_shell.omp.json")"
  rm -rf "$root"

  if [[ -n "$actual" && "$actual" == "$expected" ]]; then
    pass "$statement"
  else
    fail "$statement" "oh-my-posh read: ${(qqq)actual}"
  fi
}

assert_repair_keeps_the_old_theme() {
  local statement="the theme the repair replaces is kept as 1_shell.omp.json.before-link.*"
  local root; root="$(fixture_with_ml4w_theme)"
  posh_config "$root" >/dev/null
  local kept=("$root/home/.mydotfiles/ohmyposh/1_shell.omp.json.before-link."*(N))
  local actual=""; (( ${#kept} == 1 )) && actual="$(<"$kept[1]")"
  rm -rf "$root"

  if [[ "$actual" == "the theme ml4w left here" ]]; then
    pass "$statement"
  else
    fail "$statement" "kept ${#kept} file(s), contents: ${(qqq)actual}"
  fi
}

assert_second_shell_keeps_no_second_copy() {
  local statement="a second shell finds the link in place and keeps one old theme"
  local root; root="$(fixture_with_ml4w_theme)"
  posh_config "$root" >/dev/null; posh_config "$root" >/dev/null
  local kept=("$root/home/.mydotfiles/ohmyposh/1_shell.omp.json.before-link."*(N))
  rm -rf "$root"

  if (( ${#kept} == 1 )); then
    pass "$statement"
  else
    fail "$statement" "kept ${#kept} file(s)"
  fi
}

# The same switch that leaves ~/.zshrc alone (zshenv), for running ml4w as it ships.
assert_opting_out_keeps_the_local_theme() {
  local statement="with ZSHRC_NO_SELF_HEAL=1, a theme in ~/.config/ohmyposh stays a file and wins over this repo's copy"
  local root; root="$(fixture_with_ml4w_theme)"
  local actual; actual="$(posh_config "$root" ZSHRC_NO_SELF_HEAL=1)"
  local expected="$root/home/.config/ohmyposh/1_shell.omp.json"
  local still_a_file=no; [[ -f "$expected" && ! -L "$expected" ]] && still_a_file=yes
  rm -rf "$root"

  if [[ "$actual" == "$expected" && "$still_a_file" == yes ]]; then
    pass "$statement"
  else
    fail "$statement" "got: ${(qqq)actual}, still a file: $still_a_file"
  fi
}

# A .toml wins the lookup, so a link beside it would change nothing on screen.
assert_toml_theme_is_left_alone() {
  local statement="a shell with a 1_shell.toml starts on that file and leaves the .omp.json a file"
  local root; root="$(fixture_with_ml4w_theme)"
  : > "$root/home/.config/ohmyposh/1_shell.toml"
  local actual; actual="$(posh_config "$root")"
  local expected="$root/home/.config/ohmyposh/1_shell.toml"
  local json="$root/home/.config/ohmyposh/1_shell.omp.json"
  local still_a_file=no; [[ -f "$json" && ! -L "$json" ]] && still_a_file=yes
  rm -rf "$root"

  if [[ "$actual" == "$expected" && "$still_a_file" == yes ]]; then
    pass "$statement"
  else
    fail "$statement" "got: ${(qqq)actual}, still a file: $still_a_file"
  fi
}

# frankenstein's case: the repo's copy already wins, so nothing needs a folder or a link.
assert_machine_without_a_local_theme_gets_no_folder() {
  local statement="with no theme in ~/.config/ohmyposh, the shell leaves that folder uncreated"
  local root; root="$(new_fixture)"
  posh_config "$root" >/dev/null
  local created=no; [[ -e "$root/home/.config/ohmyposh" ]] && created=yes
  rm -rf "$root"

  if [[ "$created" == no ]]; then
    pass "$statement"
  else
    fail "$statement" "the folder exists"
  fi
}

# The Mac's case: oh-my-posh ships its own 1_shell theme, and Homebrew installs it in its themes folder.
assert_repo_theme_wins_over_homebrews_stock_theme() {
  local statement="with Homebrew's stock 1_shell theme installed, the prompt uses this repo's 1_shell theme"
  local root; root="$(new_fixture)"
  mkdir -p "$root/brew/themes"
  print -r -- '{}' > "$root/brew/themes/1_shell.omp.json"
  print -r -- "#!/bin/sh
echo '$root/brew'" > "$root/bin/brew"
  chmod +x "$root/bin/brew"
  local actual; actual="$(posh_config "$root")"
  rm -rf "$root"

  if [[ "$actual" == "$repo_dir/ohmyposh/1_shell.omp.json" ]]; then
    pass "$statement"
  else
    fail "$statement" "got: ${(qqq)actual}"
  fi
}

assert_repo_theme_wins_over_homebrews_stock_theme
assert_repo_theme_is_used_without_a_local_one
assert_nothing_is_downloaded_without_a_local_theme
assert_ml4w_theme_becomes_a_link_to_the_repo_theme
assert_the_shell_that_repairs_starts_on_the_repo_theme
assert_repair_keeps_the_old_theme
assert_second_shell_keeps_no_second_copy
assert_opting_out_keeps_the_local_theme
assert_toml_theme_is_left_alone
assert_machine_without_a_local_theme_gets_no_folder

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
