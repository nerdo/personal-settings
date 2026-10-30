#!/usr/bin/env zsh
# Tests for ../bin/install-oh-my-posh: on Linux, the pinned oh-my-posh release in ~/.local/bin, checked against its
# pinned sha256; nothing at all where oh-my-posh is already on PATH.
# Run: zsh zsh/tests/install-oh-my-posh.test.zsh

set -u

script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
installer="$repo_dir/zsh/bin/install-oh-my-posh"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

# The amd64 digest the installer pins, read from the installer itself.
pinned_amd64="$(sed -n 's/^sha256_amd64=//p' "$installer" 2>/dev/null)"

# A throwaway home and a stub bin/ holding:
#   uname      reports x86_64 Linux;
#   curl       records its arguments and writes FAKE-BINARY to its -o file;
#   sha256sum  prints the digest in $root/digest for its file, as sha256sum does.
new_fixture() {
  local root; root="$(mktemp -d)"
  mkdir -p "$root/home" "$root/bin"
  print -r -- '#!/bin/sh
case "$1" in -m) echo x86_64 ;; *) echo Linux ;; esac' > "$root/bin/uname"
  print -r -- "#!/bin/sh
echo \"\$*\" >> '$root/downloads'
while [ \$# -gt 0 ]; do [ \"\$1\" = -o ] && { printf FAKE-BINARY > \"\$2\"; }; shift; done" > "$root/bin/curl"
  print -r -- "#!/bin/sh
printf '%s  %s\n' \"\$(cat '$root/digest')\" \"\$1\"" > "$root/bin/sha256sum"
  chmod +x "$root/bin/"*
  print -r -- "$root"
}

run_installer() {  # ROOT
  env -i HOME="$1/home" PATH="$1/bin:/usr/bin:/bin" zsh -f "$installer" >/dev/null 2>&1
}

assert_nothing_is_downloaded_when_already_installed() {
  local root; root="$(new_fixture)"
  print -r -- '#!/bin/sh' > "$root/bin/oh-my-posh"; chmod +x "$root/bin/oh-my-posh"
  print -r -- "$pinned_amd64" > "$root/digest"
  run_installer "$root"
  local actual=""; [[ -f "$root/downloads" ]] && actual="$(<"$root/downloads")"
  rm -rf "$root"

  if [[ -z "$actual" ]]; then
    pass "with oh-my-posh already on PATH, install-oh-my-posh downloads nothing"
  else
    fail "with oh-my-posh already on PATH, install-oh-my-posh downloads nothing" "curl ran with: ${(qqq)actual}"
  fi
}

assert_pinned_release_lands_in_local_bin() {
  local root; root="$(new_fixture)"
  print -r -- "$pinned_amd64" > "$root/digest"
  run_installer "$root"
  local actual=""; [[ -x "$root/home/.local/bin/oh-my-posh" ]] && actual="$(<"$root/home/.local/bin/oh-my-posh")"
  rm -rf "$root"

  if [[ "$actual" == "FAKE-BINARY" ]]; then
    pass "on x86_64 Linux without oh-my-posh, the downloaded release is the executable ~/.local/bin/oh-my-posh"
  else
    fail "on x86_64 Linux without oh-my-posh, the downloaded release is the executable ~/.local/bin/oh-my-posh" \
      "~/.local/bin/oh-my-posh holds: ${(qqq)actual}"
  fi
}

assert_mismatched_digest_installs_nothing() {
  local root; root="$(new_fixture)"
  print -r -- "0000000000000000000000000000000000000000000000000000000000000000" > "$root/digest"
  run_installer "$root"
  local actual; actual="$(ls -A "$root/home/.local/bin" 2>/dev/null)"
  rm -rf "$root"

  if [[ -z "$actual" ]]; then
    pass "a download whose sha256 is not the pinned one leaves nothing in ~/.local/bin"
  else
    fail "a download whose sha256 is not the pinned one leaves nothing in ~/.local/bin" "found: ${(qqq)actual}"
  fi
}

assert_mismatched_digest_exits_non_zero() {
  local root; root="$(new_fixture)"
  print -r -- "0000000000000000000000000000000000000000000000000000000000000000" > "$root/digest"
  run_installer "$root"
  local actual=$?
  rm -rf "$root"

  if (( actual != 0 )); then
    pass "a download whose sha256 is not the pinned one exits non-zero"
  else
    fail "a download whose sha256 is not the pinned one exits non-zero" "exit status: $actual"
  fi
}

assert_nothing_is_downloaded_when_already_installed
assert_pinned_release_lands_in_local_bin
assert_mismatched_digest_installs_nothing
assert_mismatched_digest_exits_non_zero

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
