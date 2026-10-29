# sec: get and set Dannel's keys in OpenBao (kv/dannel/…) from the command line. Sourced by zsh/custom/150-secretspec.
#
#   sec ls [PATH]           item names under kv/dannel/PATH
#   sec fields ITEM         field names in kv/dannel/ITEM (never values)
#   sec get ITEM FIELD      at a terminal: to the clipboard, cleared after SEC_CLIP_SECONDS (45); in a pipe: to stdout
#   sec get -c ITEM FIELD   always to the clipboard
#   sec set ITEM FIELD      value from a pipe (`pbpaste | sec set …`) or a hidden prompt; keeps the item's other
#                           fields; then clears SecretSpec's cache so the next read gets the new value
#
# No value goes on a command line, into history or onto the screen. Each command logs in as dannel with the AppRole
# login in the keyring (service strflt-openbao-dannel, accounts role_id and secret_id) and revokes the token after.
# Deleting a field, old versions and rollback: OpenBao's web interface, or `bao kv rollback -mount=kv …`.
SEC_BAO_ADDR="${SEC_BAO_ADDR:-https://scrts.strflt.com}"
SEC_KEYRING_SERVICE="${SEC_KEYRING_SERVICE:-strflt-openbao-dannel}"
_SEC_MANIFEST="${${(%):-%x}:A:h}/secretspec.toml"

_sec_keyring() {  # ACCOUNT -> the value, for a pipe
  if (( $+commands[security] )); then security find-generic-password -s "$SEC_KEYRING_SERVICE" -a "$1" -w 2>/dev/null
  # SecretSpec (keyring-rs) stores the account as `username`; `account` is for entries made with secret-tool by hand.
  else secret-tool lookup service "$SEC_KEYRING_SERVICE" username "$1" 2>/dev/null \
    || secret-tool lookup service "$SEC_KEYRING_SERVICE" account "$1" 2>/dev/null; fi
}
_sec_copy()  { if (( $+commands[pbcopy] )); then pbcopy; elif (( $+commands[wl-copy] )); then wl-copy; else xclip -selection clipboard; fi }
_sec_paste() { if (( $+commands[pbpaste] )); then pbpaste; elif (( $+commands[wl-paste] )); then wl-paste -n; else xclip -selection clipboard -o; fi }

sec() {
  local cmd="${1:-}"; (( $# )) && shift
  local A="$SEC_BAO_ADDR/v1" t
  t=$(jq -n --rawfile r <(_sec_keyring role_id | tr -d '\n') --rawfile s <(_sec_keyring secret_id | tr -d '\n') '{role_id: $r, secret_id: $s}' \
    | curl -sS -X POST --data @- "$A/auth/approle/login" | jq -r '.auth.client_token // empty')
  [[ -n $t ]] || { print -u2 "sec: OpenBao login as dannel failed (keyring $SEC_KEYRING_SERVICE, $SEC_BAO_ADDR)"; return 1; }
  # A fresh header per call: a process substitution is a pipe and can be read only once.
  _sec_curl() { curl -sS -H @<(printf 'X-Vault-Token: %s\n' "$t") "$@"; }
  {
    case $cmd in
      ls)     _sec_curl -X LIST "$A/kv/metadata/dannel/${1:-}" | jq -r '.data.keys[]?' ;;
      fields) _sec_curl "$A/kv/data/dannel/$1" | jq -r '.data.data // {} | keys[]' ;;
      get)
        local clip=0; [[ ${1:-} == -c ]] && { clip=1; shift; }
        [[ -t 1 ]] && clip=1
        local item=$1 field=$2
        if (( clip )); then
          _sec_curl "$A/kv/data/dannel/$item" | jq -j --arg f "$field" '.data.data[$f] // empty' | _sec_copy
          local secs=${SEC_CLIP_SECONDS:-45}
          print -u2 "sec: kv/dannel/$item $field copied to the clipboard; cleared in ${secs}s"
          # Detached from stdin, stdout and stderr, so a caller reading this command's output does not wait for it.
          ( sleep $secs; print -rn -- "" | _sec_copy ) </dev/null >/dev/null 2>&1 &!
        else
          _sec_curl "$A/kv/data/dannel/$item" | jq -j --arg f "$field" '.data.data[$f] // empty'
        fi ;;
      set)
        local item=$1 field=$2 v code u="$A/kv/data/dannel/$1"
        if [[ -t 0 ]]; then read -rs "v?Value for kv/dannel/$item $field: "; print -u2
        else v=$(cat; print -n x); v=${v%x}; fi
        while [[ $v == *$'\n' ]]; do v=${v%$'\n'}; done
        [[ -n $v ]] || { print -u2 "sec: empty value; nothing stored"; return 1; }
        _sec_body() { jq -n --rawfile v <(print -rn -- "$v") --arg k "$field" '{data: {($k): $v}}'; }
        code=$(_sec_body | _sec_curl -o /dev/null -w '%{http_code}' -H 'Content-Type: application/merge-patch+json' -X PATCH --data @- "$u")
        [[ $code == 404 ]] && code=$(_sec_body | _sec_curl -o /dev/null -w '%{http_code}' -X POST --data @- "$u")
        unset v
        [[ $code == 2* ]] || { print -u2 "sec: storing kv/dannel/$item $field failed (HTTP $code)"; return 1; }
        local version=$(_sec_curl "$A/kv/metadata/dannel/$item" | jq -r '.data.current_version // "?"')
        local -a profiles=(${(f)"$(grep -o '^\[profiles\.[^].]*' "$_SEC_MANIFEST" 2>/dev/null | sed 's/^\[profiles\.//')"})
        for p in $profiles; do secretspec -f "$_SEC_MANIFEST" cache clear --profile "$p" >/dev/null 2>&1; done
        print -u2 "sec: kv/dannel/$item $field stored (version $version); SecretSpec cache cleared (${#profiles} profiles)" ;;
      *) print -u2 "usage: sec ls [PATH] | sec fields ITEM | sec get [-c] ITEM FIELD | sec set ITEM FIELD"; return 2 ;;
    esac
  } always {
    _sec_curl -o /dev/null -X POST "$A/auth/token/revoke-self"
    unset t
  }
}
