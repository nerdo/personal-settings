#!/usr/bin/env zsh
# Tests for `sec` (../../secretspec/sec.zsh) against a throwaway OpenBao dev server.
# Run: zsh zsh/tests/sec.test.zsh
#
# Fake `security` (the Keychain), `pbcopy`/`pbpaste` (the clipboard) and `secretspec` sit first on PATH, so no real
# login, clipboard or cache is touched. Needs `bao` (brew install openbao); without it the suite fails loudly.

set -u
script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
failures=0
pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

whence -p bao >/dev/null || { print -r -- "FAIL - bao is not installed (brew install openbao)"; exit 1; }

tmp_dir="$(mktemp -d)"
port=$(( 20000 + RANDOM % 20000 ))
addr="http://127.0.0.1:$port"
bao server -dev -dev-root-token-id=root -dev-listen-address=127.0.0.1:$port >/dev/null 2>&1 &
server_pid=$!
trap 'kill $server_pid 2>/dev/null; rm -rf "$tmp_dir"' EXIT
for i in {1..100}; do curl -s -o /dev/null "$addr/v1/sys/health" && break; sleep 0.05; done

root() { curl -sS -H 'X-Vault-Token: root' "$@"; }
root -X POST --data '{"type":"kv","options":{"version":"2"}}' "$addr/v1/sys/mounts/kv" >/dev/null
root -X POST --data '{"type":"approle"}' "$addr/v1/sys/auth/approle" >/dev/null
root -X PUT --data "$(jq -n '{policy: "path \"kv/data/dannel/*\" { capabilities = [\"create\",\"read\",\"update\",\"patch\"] }\npath \"kv/metadata/dannel/*\" { capabilities = [\"read\",\"list\"] }\npath \"kv/metadata/dannel/\" { capabilities = [\"list\"] }"}')" "$addr/v1/sys/policies/acl/dannel" >/dev/null
root -X POST --data '{"token_policies":["dannel"]}' "$addr/v1/auth/approle/role/dannel" >/dev/null
role_id=$(root "$addr/v1/auth/approle/role/dannel/role-id" | jq -r .data.role_id)
secret_id=$(root -X POST "$addr/v1/auth/approle/role/dannel/secret-id" | jq -r .data.secret_id)

mkdir -p "$tmp_dir/bin"
clip="$tmp_dir/clipboard"; calls="$tmp_dir/secretspec-calls"
print -r -- "#!/usr/bin/env zsh
case \"\$*\" in *role_id*) print -r -- '$role_id';; *secret_id*) print -r -- '$secret_id';; *) exit 44;; esac" > "$tmp_dir/bin/security"
print -r -- "#!/usr/bin/env zsh
cat > '$clip'" > "$tmp_dir/bin/pbcopy"
print -r -- "#!/usr/bin/env zsh
cat '$clip' 2>/dev/null" > "$tmp_dir/bin/pbpaste"
print -r -- "#!/usr/bin/env zsh
print -r -- \"\$*\" >> '$calls'" > "$tmp_dir/bin/secretspec"
chmod +x "$tmp_dir/bin/"*
PATH="$tmp_dir/bin:$PATH"
export SEC_BAO_ADDR="$addr"

source "$repo_dir/secretspec/sec.zsh"

stored() { root "$addr/v1/kv/data/dannel/$1" | jq -r --arg f "$2" '.data.data[$f] // "<missing>"'; }
tokens() { root -X LIST "$addr/v1/auth/token/accessors" | jq '.data.keys | length'; }

print -rn -- "fx-value-1" | sec set github GITHUB_PERSONAL_ACCESS_TOKEN >/dev/null 2>&1
[[ "$(stored github GITHUB_PERSONAL_ACCESS_TOKEN)" == fx-value-1 ]] && pass "sec set stores a piped value in the field" \
  || fail "sec set stores a piped value in the field" "stored: $(stored github GITHUB_PERSONAL_ACCESS_TOKEN)"

print -r -- "fx-other" | sec set github GITHUB_MCP_TOKEN >/dev/null 2>&1
[[ "$(stored github GITHUB_PERSONAL_ACCESS_TOKEN)" == fx-value-1 ]] && pass "sec set keeps the item's other fields" \
  || fail "sec set keeps the item's other fields" "first field now: $(stored github GITHUB_PERSONAL_ACCESS_TOKEN)"

[[ "$(stored github GITHUB_MCP_TOKEN)" == fx-other ]] && pass "sec set drops the trailing newline a pipe adds" \
  || fail "sec set drops the trailing newline a pipe adds" "stored: ${(qqq)$(stored github GITHUB_MCP_TOKEN)}"

rg -q -- 'cache clear' "$calls" 2>/dev/null && pass "sec set clears SecretSpec's cache" \
  || fail "sec set clears SecretSpec's cache" "secretspec calls: $(cat "$calls" 2>/dev/null)"

out="$(sec set github GITHUB_MCP_TOKEN 2>&1 <<< "fx-secret-out")"
[[ $out != *fx-secret-out* ]] && pass "sec set prints no value" || fail "sec set prints no value" "output contained the value"

[[ "$(sec get github GITHUB_PERSONAL_ACCESS_TOKEN | cat)" == fx-value-1 ]] && pass "sec get writes the value to a pipe" \
  || fail "sec get writes the value to a pipe" "pipe received something else"

rm -f "$clip"; out="$(sec get -c github GITHUB_PERSONAL_ACCESS_TOKEN 2>&1)"
[[ "$(cat "$clip" 2>/dev/null)" == fx-value-1 ]] && pass "sec get -c puts the value on the clipboard" \
  || fail "sec get -c puts the value on the clipboard" "clipboard: $(cat "$clip" 2>/dev/null)"
[[ $out != *fx-value-1* ]] && pass "sec get -c prints no value" || fail "sec get -c prints no value" "output contained the value"

rm -f "$clip"; SEC_CLIP_SECONDS=1 sec get -c github GITHUB_PERSONAL_ACCESS_TOKEN >/dev/null 2>&1; sleep 2
[[ -z "$(cat "$clip" 2>/dev/null)" ]] && pass "the clipboard is cleared after SEC_CLIP_SECONDS" \
  || fail "the clipboard is cleared after SEC_CLIP_SECONDS" "clipboard still holds a value"

[[ "$(sec ls 2>/dev/null)" == *github* ]] && pass "sec ls lists item names" || fail "sec ls lists item names" "got: $(sec ls 2>&1)"

f="$(sec fields github 2>/dev/null | sort | paste -sd' ' -)"
[[ $f == "GITHUB_MCP_TOKEN GITHUB_PERSONAL_ACCESS_TOKEN" ]] && pass "sec fields lists field names, not values" \
  || fail "sec fields lists field names, not values" "got: $f"

before=$(tokens); sec get github GITHUB_PERSONAL_ACCESS_TOKEN >/dev/null 2>&1; after=$(tokens)
(( after == before )) && pass "sec leaves no login token behind" || fail "sec leaves no login token behind" "tokens before $before, after $after"

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
