#!/usr/bin/env zsh
# Tests for the with-secrets command (./with-secrets), run through its bin/ symlinks the way a program starts them:
# outside zsh, with no shell functions, with bin/ first on PATH (zsh/bin/install-bin-path, 990-commands).
# Run: zsh commands/with-secrets/with-secrets.test.zsh

set -u

command_dir="${0:A:h}"
repo_dir="${command_dir:h:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
fake_home="$tmp_dir/home"
mkdir -p "$tmp_dir/real" "$fake_home"
args_file="$tmp_dir/child-args"

# Fake real programs, later on PATH than bin/, as mise's shims are for Orca. Each prints the keys it was
# given and records its arguments. Paths are baked into the script text, because the environment is under test.
for name in gh npx bun; do
  cat > "$tmp_dir/real/$name" <<FAKE
#!/bin/sh
printf '%s\n' "\$*" > "$args_file"
printf 'GITHUB_TOKEN=%s\n' "\${GITHUB_TOKEN:-<unset>}"
printf 'NPMJS_TOKEN=%s\n' "\${NPMJS_TOKEN:-<unset>}"
exit "\${FAKE_EXIT:-0}"
FAKE
  chmod +x "$tmp_dir/real/$name"
done

# SecretSpec reads a fixture instead of OpenBao, one value per name, named after it, so no real key is read.
fixture="$tmp_dir/fixture.env"
print -r -- "GITHUB_TOKEN=fx-GITHUB_TOKEN
NPMJS_TOKEN=fx-NPMJS_TOKEN
FONTAWESOME_TOKEN=fx-FONTAWESOME_TOKEN" > "$fixture"

# SecretSpec alone in a folder of its own, after the fakes: its real folder (Homebrew's on macOS) can hold a real gh.
secretspec_dir="$tmp_dir/secretspec-only"
mkdir -p "$secretspec_dir" && ln -s "$(whence -p secretspec)" "$secretspec_dir/secretspec"

# Starts NAME the way a systemd service such as Orca does: a bare environment, no zsh, bin/ first.
as_program() {
  env -i HOME="$fake_home" PATH="$repo_dir/bin:$tmp_dir/real:$secretspec_dir:/usr/bin:/bin" \
    SECRETSPEC_PROVIDER="dotenv:$fixture" ${FAKE_EXIT:+FAKE_EXIT=$FAKE_EXIT} "$@" 2>&1
}

output_value() {  # OUTPUT NAME
  local line; line="$(print -r -- "$1" | rg --no-line-number "^$2=" | head -1)"
  [[ -n $line ]] && print -r -- "${line#$2=}" || print -r -- "<no output: $1>"
}

expect_value() {  # LABEL OUTPUT NAME EXPECTED
  local actual; actual="$(output_value "$2" "$3")"
  [[ "$actual" == "$4" ]] && pass "$1" || fail "$1" "$3: expected '$4', received '$actual'"
}

out="$(as_program gh auth status)"
expect_value "gh started by a program outside zsh, with bin/ first on PATH, gets the gh profile's GITHUB_TOKEN" \
  "$out" GITHUB_TOKEN fx-GITHUB_TOKEN

# Design agreed with Dannel 2026-10-29 (Orca's gh panel): one shim, its name picks the program and the profile, npx,
# bun and bunx use npm's, and the keys reach that one run only. A + on the name (npm+, bun+) marks a command whose
# keys are only for a person typing it; the program is the name without the +.

as_program gh pr list --state open >/dev/null
received="<the real gh never ran>"; [[ -e "$args_file" ]] && received="$(<"$args_file")"
[[ "$received" == "pr list --state open" ]] && pass "gh hands the real gh its arguments untouched" \
  || fail "gh hands the real gh its arguments untouched" "real gh received '$received'"

FAKE_EXIT=5 as_program gh auth status >/dev/null; code=$?
(( code == 5 )) && pass "gh exits with the real gh's exit status" || fail "gh exits with the real gh's exit status" "exit $code"

out="$(as_program npx+ -v)"
expect_value "npx+ gets the npm profile's NPMJS_TOKEN" "$out" NPMJS_TOKEN fx-NPMJS_TOKEN

out="$(as_program bun -v)"
expect_value "plain bun, as a #!/usr/bin/env bun script starts it, gets no key" "$out" NPMJS_TOKEN "<unset>"

out="$(as_program gh auth status)"
expect_value "gh gets no key outside its profile" "$out" NPMJS_TOKEN "<unset>"

rm "$tmp_dir/real/gh"
out="$(as_program gh auth status)"; code=$?
(( code == 127 )) && [[ $out == *"no gh program on PATH"* ]] && pass "gh with no real gh on PATH exits 127 and says so" \
  || fail "gh with no real gh on PATH exits 127 and says so" "exit $code: $out"

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
