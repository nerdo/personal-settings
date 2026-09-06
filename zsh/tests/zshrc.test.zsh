#!/usr/bin/env zsh
# Tests for the module loader in ./zshrc.
# Run: zsh zsh/tests/zshrc.test.zsh

set -u

script_dir="${0:A:h}"
repo_zsh_dir="${script_dir:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# The loader merges ml4w's module directory with this repo's custom/. Each case
# builds both sides out of stub modules that announce themselves, so the
# assertions read the load order the shell actually produced rather than
# inferring it from filenames.
#
# The fixture home deliberately has no ~/.config/zshrc/custom symlink: that link
# lives inside the tree ml4w rebuilds, and the loader is supposed to reach its
# modules without it. Every custom module that loads here loads through the
# loader's own path.
new_fixture() {
  local root; root="$(mktemp -d)"
  mkdir -p "$root/repo/custom" "$root/home/.config/zshrc"
  cp "$repo_zsh_dir/zshrc" "$root/repo/zshrc"
  ln -s "$root/repo/zshrc" "$root/home/.zshrc"
  print -r -- "$root"
}

# $1 root, $2 ml4w|custom, $3 module name
add_module() {
  local root="$1" side="$2" name="$3"
  local dir
  case "$side" in
    ml4w)   dir="$root/home/.config/zshrc" ;;
    custom) dir="$root/repo/custom" ;;
  esac
  print -r -- "print -r -- RAN:$name:$side" > "$dir/$name"
}

# Only the announcements, in the order the loader produced them.
load_order() {
  local root="$1"
  env -i HOME="$root/home" PATH="$PATH" TERM=xterm zsh -i -c 'true' 2>/dev/null \
    | grep '^RAN:'
}

# The whole reason ~/.zshrc points at this loader: ml4w's own loader walks its
# module directory and swaps in same-named custom files, so a module that exists
# only in custom/ never runs under it.
assert_custom_only_module_is_sourced() {
  local root; root="$(new_fixture)"
  add_module "$root" ml4w 25-aliases
  add_module "$root" custom 900-mine

  local actual; actual="$(load_order "$root")"
  rm -rf "$root"

  if [[ "$actual" == *"RAN:900-mine:custom"* ]]; then
    pass "a module only in custom/ is sourced"
  else
    fail "a module only in custom/ is sourced" "got: ${(qqq)actual}"
  fi
}

# The override case: same name on both sides means custom/ replaces ml4w's copy
# rather than running after it.
assert_custom_wins_a_name_collision() {
  local root; root="$(new_fixture)"
  add_module "$root" ml4w 00-init
  add_module "$root" custom 00-init

  local actual; actual="$(load_order "$root")"
  rm -rf "$root"

  if [[ "$actual" == "RAN:00-init:custom" ]]; then
    pass "custom/ wins a name collision and ml4w's copy is skipped"
  else
    fail "custom/ wins a name collision and ml4w's copy is skipped" "got: ${(qqq)actual}"
  fi
}

# ml4w numbers with two digits where this repo zero-pads to three, so the names
# never collide and both copies would otherwise run. Under ml4w's real
# 20-customization that means oh-my-zsh, fzf, and the prompt are set up twice,
# with ml4w's prompt landing last and winning.
assert_zero_padded_module_supersedes_ml4w() {
  local root; root="$(new_fixture)"
  add_module "$root" ml4w 20-customization
  add_module "$root" custom 020-customization

  local actual; actual="$(load_order "$root")"
  rm -rf "$root"

  if [[ "$actual" == "RAN:020-customization:custom" ]]; then
    pass "a zero-padded custom module supersedes ml4w's unpadded one"
  else
    fail "a zero-padded custom module supersedes ml4w's unpadded one" "got: ${(qqq)actual}"
  fi
}

# Superseding must stay narrow: ml4w modules this repo has no counterpart for
# still carry ml4w's aliases and autostart, and dropping them would be a silent
# regression.
assert_ml4w_only_module_still_runs() {
  local root; root="$(new_fixture)"
  add_module "$root" ml4w 30-autostart
  add_module "$root" custom 900-mine

  local actual; actual="$(load_order "$root")"
  rm -rf "$root"

  if [[ "$actual" == *"RAN:30-autostart:ml4w"* ]]; then
    pass "an ml4w-only module still runs"
  else
    fail "an ml4w-only module still runs" "got: ${(qqq)actual}"
  fi
}

# Numbering exists to control order, and the numbers only mean anything if the
# loader honours them across both directories.
assert_modules_load_in_number_order() {
  local root; root="$(new_fixture)"
  add_module "$root" custom 010-path
  add_module "$root" ml4w 25-aliases
  add_module "$root" custom 100-tool
  add_module "$root" custom 900-mine

  local actual; actual="$(load_order "$root")"
  rm -rf "$root"

  local expected="RAN:010-path:custom
RAN:100-tool:custom
RAN:25-aliases:ml4w
RAN:900-mine:custom"

  if [[ "$actual" == "$expected" ]]; then
    pass "modules load in number order across both directories"
  else
    fail "modules load in number order across both directories" "got: ${(qqq)actual}"
  fi
}

# ~/.zshrc_custom is the machine-local escape hatch both loaders honour, and it
# has to keep landing last so it can override anything a module set.
assert_zshrc_custom_is_sourced_last() {
  local root; root="$(new_fixture)"
  add_module "$root" custom 900-mine
  print -r -- 'print -r -- RAN:zshrc_custom:home' > "$root/home/.zshrc_custom"

  local actual; actual="$(load_order "$root")"
  rm -rf "$root"

  local expected="RAN:900-mine:custom
RAN:zshrc_custom:home"

  if [[ "$actual" == "$expected" ]]; then
    pass "~/.zshrc_custom is sourced last"
  else
    fail "~/.zshrc_custom is sourced last" "got: ${(qqq)actual}"
  fi
}

# macOS has no ml4w, so ~/.config/zshrc does not exist at all. The loader must
# start clean from custom/ alone instead of erroring on the missing directory.
assert_works_without_the_ml4w_directory() {
  local root; root="$(new_fixture)"
  rm -rf "$root/home/.config"
  add_module "$root" custom 900-mine

  local output actual
  output="$(env -i HOME="$root/home" PATH="$PATH" TERM=xterm zsh -i -c 'true' 2>/dev/null)"
  actual="$(print -r -- "$output" | grep '^RAN:')"
  rm -rf "$root"

  if [[ "$actual" == "RAN:900-mine:custom" && "$output" == "$actual" ]]; then
    pass "the loader works with no ml4w directory present"
  else
    fail "the loader works with no ml4w directory present" "got: ${(qqq)output}"
  fi
}

assert_custom_only_module_is_sourced
assert_custom_wins_a_name_collision
assert_zero_padded_module_supersedes_ml4w
assert_ml4w_only_module_still_runs
assert_modules_load_in_number_order
assert_zshrc_custom_is_sourced_last
assert_works_without_the_ml4w_directory

if (( failures > 0 )); then
  print -r -- ""
  print -r -- "$failures assertion(s) failed"
  exit 1
fi

print -r -- ""
print -r -- "all assertions passed"
