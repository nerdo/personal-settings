# Per-command secrets through SecretSpec (secretspec.toml beside this file). Sourced by zsh/custom/150-secretspec.
#
# with_secrets PROFILE PROGRAM [ARGS…] runs PROGRAM, a program on PATH (never a shell function), with PROFILE's keys
# added to its environment; nothing else gets them. The functions below give each command its profile; claude,
# claude-tsi, omp and dsh call with_secrets from their own functions in custom/900-aliases.
SECRETSPEC_MANIFEST="${SECRETSPEC_MANIFEST:-${${(%):-%x}:A:h}/secretspec.toml}"

with_secrets() {
  local profile="$1"; shift
  # The word after the profile is the program; check it first so a slip like `with_secrets gh auth status` reads plainly.
  if ! whence -p -- "${1:-}" >/dev/null; then
    print -u2 "with_secrets: '${1:-}' is not a program. Usage: with_secrets PROFILE PROGRAM [ARGS…]"
    print -u2 "  for example: with_secrets $profile $profile ${1:-} ${(j: :)@[2,-1]}   (or the wrapper alone: $profile ${1:-} ${(j: :)@[2,-1]})"
    return 127
  fi
  secretspec -f "$SECRETSPEC_MANIFEST" run --profile "$profile" \
    --reason "${SECRETSPEC_REASON:-$profile (settings alias)}" -- "$@"
}

npm()      { with_secrets npm npm "$@" }
npx()      { with_secrets npm npx "$@" }
bun()      { with_secrets npm bun "$@" }
bunx()     { with_secrets npm bunx "$@" }
gh()       { with_secrets gh gh "$@" }
jira()     { with_secrets jira jira "$@" }
semgrep()  { with_secrets semgrep semgrep "$@" }
spock-me() { with_secrets spock-me spock-me "$@" }
