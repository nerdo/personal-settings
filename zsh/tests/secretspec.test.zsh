#!/usr/bin/env zsh
# Tests for the per-command secret loading in ../../secretspec/ (aliases.zsh and secretspec.toml).
# Run: zsh zsh/tests/secretspec.test.zsh
#
# SecretSpec reads a fixture file instead of OpenBao (SECRETSPEC_PROVIDER=dotenv:…), and fake programs on PATH dump
# the environment they were started with. Every managed name is removed from this shell first, so a value the fake
# receives can only have come from SecretSpec, and no real value reaches a dump file.

set -u

script_dir="${0:A:h}"
repo_dir="${script_dir:h:h}"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

managed=(CONTEXT7_API_KEY LANGFUSE_BASE_URL LANGFUSE_HOST LANGFUSE_PUBLIC_KEY LANGFUSE_SECRET_KEY GITHUB_TOKEN
  GITHUB_PERSONAL_ACCESS_TOKEN NPMJS_TOKEN FONTAWESOME_TOKEN N8N_API_KEY N8N_API_URL UNIFI_API_KEY UNIFI_NETWORK_HOST
  UNIFI_NETWORK_USERNAME UNIFI_NETWORK_PASSWORD HOMEASSISTANT_TOKEN HOMEASSISTANT_URL JIRA_API_TOKEN SEMGREP_APP_TOKEN
  SPOCK_TELEGRAM_MESSAGE_WEBHOOK_AUTH_HEADER SPOCK_TELEGRAM_MESSAGE_WEBHOOK_URL TSI_N8N_API_KEY TSI_N8N_API_URL
  NTFY_TOKEN OPENAI_API_KEY TSI_NTFY_TOKEN TSI_OPENAI_API_KEY COMMAND_RUNNER_SLACK_TOKEN COOLIFY_API_KEY GITHUB_MCP_TOKEN)
unset $managed CLAUDE_CONFIG_DIR LANGFUSE_TRACING_ENVIRONMENT

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/bin"
dump_file="$tmp_dir/child-env"
for name in npm npx bun bunx jira semgrep spock-me claude omp dsh prime-directive; do
  print -r -- "#!/usr/bin/env zsh
env > '$dump_file'
[[ \${0:t} == prime-directive ]] && print 'fake corpus'
true" > "$tmp_dir/bin/$name"
  chmod +x "$tmp_dir/bin/$name"
done
# The real bun parses the manifest below; recorded before the fakes shadow it on PATH.
real_bun="$(whence -p bun)"
PATH="$tmp_dir/bin:$PATH"

# One fixture value per name, named after it, so a wrong mapping shows as the wrong name.
fixture="$tmp_dir/fixture.env"
for name in $managed; do print -r -- "$name=fx-$name"; done > "$fixture"
export SECRETSPEC_PROVIDER="dotenv:$fixture"

source "$repo_dir/secretspec/aliases.zsh"
source "$repo_dir/zsh/custom/900-aliases"

child_env_value() {
  local line; line="$(rg --no-line-number "^$1=" "$dump_file" 2>/dev/null | head -1)"
  [[ -n $line ]] && print -r -- "${line#$1=}" || print -r -- "<unset>"
}
run() { rm -f "$dump_file"; "$@" >/dev/null 2>&1; }
expect_env() {  # LABEL NAME EXPECTED
  local actual; actual="$(child_env_value "$2")"
  [[ "$actual" == "$3" ]] && pass "$1" || fail "$1" "$2: expected '$3', child received '$actual'"
}

run npm whoami;            expect_env "npm gets NPMJS_TOKEN from SecretSpec" NPMJS_TOKEN fx-NPMJS_TOKEN
run npm whoami;            expect_env "npm gets GITHUB_TOKEN for ~/.npmrc" GITHUB_TOKEN fx-GITHUB_TOKEN
run npm whoami;            expect_env "npm gets no key outside its profile" LANGFUSE_SECRET_KEY "<unset>"
run npx -v;                expect_env "npx gets FONTAWESOME_TOKEN from SecretSpec" FONTAWESOME_TOKEN fx-FONTAWESOME_TOKEN
run bun -v;                expect_env "bun gets NPMJS_TOKEN from SecretSpec" NPMJS_TOKEN fx-NPMJS_TOKEN
run bunx -v;               expect_env "bunx gets NPMJS_TOKEN from SecretSpec" NPMJS_TOKEN fx-NPMJS_TOKEN
run jira issue list;       expect_env "jira gets JIRA_API_TOKEN from SecretSpec" JIRA_API_TOKEN fx-JIRA_API_TOKEN
run semgrep ci;            expect_env "semgrep gets SEMGREP_APP_TOKEN from SecretSpec" SEMGREP_APP_TOKEN fx-SEMGREP_APP_TOKEN
run spock-me hi;           expect_env "spock-me gets the webhook URL from SecretSpec" SPOCK_TELEGRAM_MESSAGE_WEBHOOK_URL fx-SPOCK_TELEGRAM_MESSAGE_WEBHOOK_URL
run omp;                   expect_env "omp gets LANGFUSE_SECRET_KEY from SecretSpec" LANGFUSE_SECRET_KEY fx-LANGFUSE_SECRET_KEY
run omp;                   expect_env "omp gets CONTEXT7_API_KEY from SecretSpec" CONTEXT7_API_KEY fx-CONTEXT7_API_KEY
run omp;                   expect_env "omp gets no key outside its profile" UNIFI_NETWORK_PASSWORD "<unset>"
run dsh;                   expect_env "dsh gets LANGFUSE_HOST from SecretSpec" LANGFUSE_HOST fx-LANGFUSE_HOST
run claude;                expect_env "claude gets N8N_API_KEY from SecretSpec" N8N_API_KEY fx-N8N_API_KEY
run claude;                expect_env "claude gets UNIFI_NETWORK_PASSWORD from SecretSpec" UNIFI_NETWORK_PASSWORD fx-UNIFI_NETWORK_PASSWORD
run claude;                expect_env "claude gets HOMEASSISTANT_TOKEN from SecretSpec" HOMEASSISTANT_TOKEN fx-HOMEASSISTANT_TOKEN
run claude;                expect_env "claude still gets its tracing environment" LANGFUSE_TRACING_ENVIRONMENT claude-code-personal
run claude-tsi;            expect_env "claude-tsi gets JIRA_API_TOKEN from SecretSpec" JIRA_API_TOKEN fx-JIRA_API_TOKEN
run claude-tsi;            expect_env "claude-tsi still gets its own config dir" CLAUDE_CONFIG_DIR "$HOME/.claude-tsi"
run claude-tsi;            expect_env "claude-tsi gets no OPENAI_API_KEY (on demand only)" OPENAI_API_KEY "<unset>"
# Keys no command loads by itself: each has its own profile, used explicitly with with_secrets.
run with_secrets openai npm;          expect_env "with_secrets openai gives OPENAI_API_KEY" OPENAI_API_KEY fx-OPENAI_API_KEY
run with_secrets openai npm;          expect_env "with_secrets openai gives nothing else" NPMJS_TOKEN "<unset>"
run with_secrets slack npm;           expect_env "with_secrets slack gives COMMAND_RUNNER_SLACK_TOKEN" COMMAND_RUNNER_SLACK_TOKEN fx-COMMAND_RUNNER_SLACK_TOKEN
run with_secrets coolify npm;         expect_env "with_secrets coolify gives COOLIFY_API_KEY" COOLIFY_API_KEY fx-COOLIFY_API_KEY
run with_secrets github-mcp npm;      expect_env "with_secrets github-mcp gives GITHUB_MCP_TOKEN" GITHUB_MCP_TOKEN fx-GITHUB_MCP_TOKEN
run claude;                expect_env "claude gets NTFY_TOKEN from SecretSpec" NTFY_TOKEN fx-NTFY_TOKEN
run claude;                expect_env "claude gets no OPENAI_API_KEY (work only)" OPENAI_API_KEY "<unset>"
# A name inherited from the parent shell must not win over the profile's value.
NTFY_TOKEN=from-parent-shell run claude-tsi
expect_env "claude-tsi's NTFY_TOKEN comes from its profile even when the parent shell has one" NTFY_TOKEN fx-NTFY_TOKEN
# The TSI_ prefix only existed while both copies were exported at once.
export TSI_NTFY_TOKEN=prefixed
run claude-tsi;            expect_env "claude-tsi does not turn a TSI_ variable into the plain name" NTFY_TOKEN fx-NTFY_TOKEN
unset TSI_NTFY_TOKEN

# Where each name points in OpenBao is the manifest's job; SecretSpec's fixture override bypasses it, so these read
# the parsed manifest.
manifest_ref() {  # PROFILE NAME -> item/field the bao alias reads
  "$real_bun" -e "const m = Bun.TOML.parse(await Bun.file('$repo_dir/secretspec/secretspec.toml').text()); const s = m.profiles?.['$1']?.['$2']; console.log(s ? s.refs.bao.item + ' ' + s.refs.bao.field : '<undeclared>')" 2>/dev/null || print -r -- "<no manifest>"
}
expect_ref() { local a; a="$(manifest_ref "$2" "$3")"; [[ "$a" == "$4" ]] && pass "$1" || fail "$1" "$2.$3: expected '$4', got '$a'"; }
expect_ref "LANGFUSE_HOST reads the same field as LANGFUSE_BASE_URL" claude LANGFUSE_HOST "dannel/langfuse LANGFUSE_BASE_URL"
expect_ref "claude's N8N_API_KEY is the personal one" claude N8N_API_KEY "dannel/n8n N8N_API_KEY"
expect_ref "claude-tsi's N8N_API_KEY is the work one" claude-tsi N8N_API_KEY "dannel/tsi/n8n N8N_API_KEY"
expect_ref "jira's JIRA_API_TOKEN is the work Jira token" jira JIRA_API_TOKEN "dannel/tsi/jira JIRA_API_TOKEN"
expect_ref "GITHUB_TOKEN reads the personal access token" npm GITHUB_TOKEN "dannel/github GITHUB_PERSONAL_ACCESS_TOKEN"
expect_ref "claude's NTFY_TOKEN is the personal one" claude NTFY_TOKEN "dannel/ntfy NTFY_TOKEN"
expect_ref "claude-tsi's NTFY_TOKEN is the work one" claude-tsi NTFY_TOKEN "dannel/tsi/ntfy NTFY_TOKEN"
expect_ref "the openai profile's OPENAI_API_KEY is the work one" openai OPENAI_API_KEY "dannel/tsi/openai OPENAI_API_KEY"
expect_ref "the slack profile reads the command-runner Slack token" slack COMMAND_RUNNER_SLACK_TOKEN "dannel/slack COMMAND_RUNNER_SLACK_TOKEN"
expect_ref "the coolify profile reads Dannel's Coolify key" coolify COOLIFY_API_KEY "dannel/coolify COOLIFY_API_KEY"
expect_ref "the github-mcp profile reads the GitHub MCP token" github-mcp GITHUB_MCP_TOKEN "dannel/github GITHUB_MCP_TOKEN"

# 100-secrets skips the names in secretspec/not-exported. A profile name missing from that list would be both
# exported to every program and served per command.
missing="$("$real_bun" -e "const m = Bun.TOML.parse(await Bun.file('$repo_dir/secretspec/secretspec.toml').text()); const served = new Set(Object.values(m.profiles).flatMap(Object.keys)); const list = new Set((await Bun.file('$repo_dir/secretspec/not-exported').text().catch(() => '')).split('\\n').map((l) => l.trim()).filter((l) => l && !l.startsWith('#'))); console.log([...served].filter((n) => !list.has(n)).join(' '))" 2>&1)"
[[ -z $missing ]] && pass "every name a profile serves is in secretspec/not-exported" || fail "every name a profile serves is in secretspec/not-exported" "missing: $missing"

(( failures == 0 )) && print -r -- "all assertions passed" || { print -r -- "$failures assertion(s) failed"; exit 1; }
