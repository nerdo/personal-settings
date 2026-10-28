# Per-command secrets through SecretSpec (secretspec.toml beside this file). Sourced by zsh/custom/150-secretspec.
#
# with_secrets PROFILE PROGRAM [ARGS…] runs PROGRAM, a program on PATH (never a shell function), with PROFILE's keys
# added to its environment; nothing else gets them. The wrappers below give each command its profile; claude,
# claude-tsi, omp and dsh call with_secrets from their own functions in custom/900-aliases, which load later.
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

# Every profile named after an installed program wraps that program: `gh` runs `with_secrets gh gh`. To make a new
# command natural, add a profile named after it to secretspec.toml and open a new shell; nothing changes here.
for _ss_profile in ${(f)"$(grep -o '^\[profiles\.[^].]*' "$SECRETSPEC_MANIFEST" 2>/dev/null | sed 's/^\[profiles\.//')"}; do
  whence -p -- "$_ss_profile" >/dev/null && functions[$_ss_profile]="with_secrets ${(q)_ss_profile} ${(q)_ss_profile} \"\$@\""
done
unset _ss_profile

# Programs that share another program's profile.
npx()  { with_secrets npm npx "$@" }
bun()  { with_secrets npm bun "$@" }
bunx() { with_secrets npm bunx "$@" }
