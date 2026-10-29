# Per-command secrets through SecretSpec (secretspec.toml beside this file). Sourced by zsh/custom/150-secretspec.
#
# with_secrets PROFILE[,PROFILE…] PROGRAM [ARGS…] runs PROGRAM, a program on PATH (never a shell function), with
# those profiles' keys added to its environment; nothing else gets them. with_secrets alone lists the profiles;
# with_secrets PROFILE[,PROFILE…] alone lists the keys a command would get, and which profile provides each. The wrappers below give each command its profile; claude,
# claude-tsi, omp and dsh call with_secrets from their own functions in custom/900-aliases, which load later.
SECRETSPEC_MANIFEST="${SECRETSPEC_MANIFEST:-${${(%):-%x}:A:h}/secretspec.toml}"

with_secrets() {
  # No arguments: list each profile with its key names (never values).
  if (( $# == 0 )); then
    awk '/^\[profiles\./ { if (p != "") print p ": " k; p = $0; sub(/^\[profiles\./, "", p); sub(/\].*/, "", p); k = ""; next }
         /^\[/            { if (p != "") print p ": " k; p = ""; next }
         p != "" && /^[A-Za-z_][A-Za-z0-9_]* *=/ { k = k (k == "" ? "" : " ") $1 }
         END              { if (p != "") print p ": " k }' "$SECRETSPEC_MANIFEST"
    return 0
  fi
  # Profiles and no program: list the keys a command would get, each with the profile that provides it (the last
  # profile listed wins for a name in several, as when running).
  if (( $# == 1 )); then
    local -a pairs=(${(f)"$(awk '/^\[profiles\./ { p = $0; sub(/^\[profiles\./, "", p); sub(/\].*/, "", p); next }
                                   /^\[/ { p = ""; next }
                                   p != "" && /^[A-Za-z_][A-Za-z0-9_]* *=/ { print p " " $1 }' "$SECRETSPEC_MANIFEST")"})
    local -A from=(); local -a order=(); local p pair k found
    for p in ${(s:,:)1}; do
      found=0
      for pair in $pairs; do
        [[ ${pair%% *} == $p ]] || continue
        found=1; k=${pair#* }
        (( ${+from[$k]} )) || order+=($k)
        from[$k]=$p
      done
      (( found )) || { print -u2 "with_secrets: no profile '$p' (with_secrets alone lists them)"; return 1; }
    done
    for k in $order; do printf '%-44s %s\n' "$k" "${from[$k]}"; done
    return 0
  fi
  local profile="$1"; shift
  # The word after the profile is the program; check it first so a slip like `with_secrets gh auth status` reads plainly.
  if ! whence -p -- "${1:-}" >/dev/null; then
    print -u2 "with_secrets: '${1:-}' is not a program. Usage: with_secrets PROFILE[,PROFILE…] PROGRAM [ARGS…]"
    print -u2 "  for example: with_secrets $profile $profile ${1:-} ${(j: :)@[2,-1]}   (or the wrapper alone: $profile ${1:-} ${(j: :)@[2,-1]})"
    return 127
  fi
  # Several profiles, comma-separated: one secretspec run per profile, nested, so the program gets all of them (a name
  # in two profiles takes the last one's value).
  local -a run=()
  local p
  for p in ${(s:,:)profile}; do
    run+=(secretspec -f "$SECRETSPEC_MANIFEST" run --profile "$p" --reason "${SECRETSPEC_REASON:-$p (settings alias)}" --)
  done
  "${run[@]}" "$@"
}

# Every profile named after an installed program wraps that program: `gh` runs `with_secrets gh gh`. To make a new
# command natural, add a profile named after it to secretspec.toml and open a new shell; nothing changes here.
# A command from this repo's bin/ (claude, claude-tsi) loads its own keys, so it is left alone.
_ss_repo_bin="${${(%):-%x}:A:h:h}/bin"
for _ss_profile in ${(f)"$(grep -o '^\[profiles\.[^].]*' "$SECRETSPEC_MANIFEST" 2>/dev/null | sed 's/^\[profiles\.//')"}; do
  [[ -e "$_ss_repo_bin/$_ss_profile" ]] && continue
  whence -p -- "$_ss_profile" >/dev/null || continue
  functions[$_ss_profile]="with_secrets ${(q)_ss_profile} ${(q)_ss_profile} \"\$@\""
done
unset _ss_profile _ss_repo_bin

# Programs that share another program's profile.
npx()  { with_secrets npm npx "$@" }
bun()  { with_secrets npm bun "$@" }
bunx() { with_secrets npm bunx "$@" }
