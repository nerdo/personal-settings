#!/usr/bin/env zsh
# Tests for ../bin/spock-me, which sends a Telegram message to Dannel through
# the "Send message via Spock to me" n8n workflow.
# Run: zsh zsh/tests/spock-me.test.zsh

set -u

script_dir="${0:A:h}"
spock_me="${script_dir:h}/bin/spock-me"
failures=0

pass() { print -r -- "ok   - $1" }
fail() { print -r -- "FAIL - $1"; print -r -- "       $2"; (( failures++ )) }

tmp_dir="$(mktemp -d)"

# --- a local stand-in for the n8n webhook -------------------------------------

# The real webhook is a GET endpoint behind n8n's Header Auth: a request whose
# header does not match gets 403 and never reaches the Telegram node. The fake
# answers the same way, so a message counts as delivered only when the header
# matched. Each delivered message lands in its own file, because a message can
# carry newlines. Every request, delivered or not, adds a line to requests.log.
fake_webhook_py="$tmp_dir/fake_webhook.py"
cat > "$fake_webhook_py" <<'PY'
import http.server, os, sys, urllib.parse

record_dir, header_name, header_value, status = sys.argv[1:5]

class Webhook(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        with open(os.path.join(record_dir, "requests.log"), "a") as log:
            log.write(self.path + "\n")
        if self.headers.get(header_name) != header_value:
            self.send_response(403)
            self.end_headers()
            self.wfile.write(b'{"message":"Authorization data is wrong!"}')
            return
        query = urllib.parse.parse_qs(urllib.parse.urlsplit(self.path).query)
        count = len([n for n in os.listdir(record_dir) if n.startswith("delivered.")])
        with open(os.path.join(record_dir, "delivered.%d" % count), "w") as out:
            out.write(query.get("message", [""])[0])
        self.send_response(int(status))
        self.end_headers()
        self.wfile.write(b'{"message":"Workflow was started"}')

    def log_message(self, *args):
        pass

server = http.server.HTTPServer(("127.0.0.1", 0), Webhook)
with open(os.path.join(record_dir, "port"), "w") as port_file:
    port_file.write(str(server.server_address[1]))
server.serve_forever()
PY

fake_header_name="X-Spock-Fixture"
fake_header_value="fixture-token-not-a-real-secret"
fake_pid=""

# Starts a fresh fake webhook answering authorized requests with $1 (default
# 200). Sets webhook_dir and webhook_url for the case that follows.
start_webhook() {
  local reply_status="${1:-200}"
  stop_webhook
  webhook_dir="$(mktemp -d "$tmp_dir/webhook.XXXXXX")"
  python3 "$fake_webhook_py" "$webhook_dir" "$fake_header_name" "$fake_header_value" "$reply_status" &
  fake_pid=$!
  local waited=0
  while [[ ! -s "$webhook_dir/port" ]] && (( waited < 50 )); do
    sleep 0.1
    (( waited++ ))
  done
  webhook_url="http://127.0.0.1:$(<"$webhook_dir/port")/webhook/fixture"
}

stop_webhook() {
  if [[ -n "$fake_pid" ]]; then
    kill "$fake_pid" 2>/dev/null
    wait "$fake_pid" 2>/dev/null
    fake_pid=""
  fi
}

trap 'stop_webhook; rm -rf "$tmp_dir"' EXIT

# --- running the command the way a shell does ---------------------------------

# spock-me is a zsh script, so zsh reads $HOME/.zshenv before it runs, and the
# real ~/.zshenv exports the real webhook URL and header over whatever the test
# set. A throwaway HOME with no .zshenv keeps every case pointed at the fake,
# and `env -i` keeps the rest of this shell's environment out of the child.
fixture_home="$(mktemp -d "$tmp_dir/home.XXXXXX")"
child_path="${commands[curl]:h}:/usr/bin:/bin"

# Runs spock-me with the fake's URL and header, plus any NAME=value words given
# before `--`. Leaves stdout, stderr, and the exit status in last_out,
# last_err, and last_status.
run_spock_me() {
  local -a extra_env
  while (( $# )) && [[ "$1" != "--" ]]; do
    extra_env+=("$1")
    shift
  done
  [[ "${1:-}" == "--" ]] && shift

  env -i HOME="$fixture_home" PATH="$child_path" \
    SPOCK_TELEGRAM_MESSAGE_WEBHOOK_URL="$webhook_url" \
    SPOCK_TELEGRAM_MESSAGE_WEBHOOK_AUTH_HEADER="$fake_header_name: $fake_header_value" \
    "${extra_env[@]}" \
    "$spock_me" "$@" > "$tmp_dir/out" 2> "$tmp_dir/err"
  last_status=$?
  last_out="$(<"$tmp_dir/out")"
  last_err="$(<"$tmp_dir/err")"
}

# The message the fake delivered to Telegram, or <nothing delivered>.
delivered_message() {
  if [[ -f "$webhook_dir/delivered.0" ]]; then
    print -rn -- "$(<"$webhook_dir/delivered.0")"
  else
    print -rn -- "<nothing delivered>"
  fi
}

assert_delivered() {
  local label="$1" expected="$2"
  local actual; actual="$(delivered_message)"
  if [[ "$actual" == "$expected" ]]; then
    pass "$label"
  else
    fail "$label" "expected Spock to deliver '$expected', delivered '$actual' (stderr: $last_err)"
  fi
}

# --- walking skeleton ---------------------------------------------------------

start_webhook
run_spock_me -- "deploy finished"
assert_delivered "spock-me with a message delivers that message to Spock" "deploy finished"

assert_status() {
  local label="$1" expected="$2"
  if [[ "$last_status" == "$expected" ]]; then
    pass "$label"
  else
    fail "$label" "expected exit status $expected, got $last_status (stderr: $last_err)"
  fi
}

assert_stderr_contains() {
  local label="$1" expected="$2"
  if [[ "$last_err" == *"$expected"* ]]; then
    pass "$label"
  else
    fail "$label" "expected stderr to contain '$expected', got '$last_err'"
  fi
}

# --- error scenarios ----------------------------------------------------------

# An empty assignment after the fake's own stands for a variable that
# ~/.secrets/export never set: env keeps the last assignment of a name.
start_webhook
run_spock_me SPOCK_TELEGRAM_MESSAGE_WEBHOOK_URL= -- "deploy finished"
assert_status "spock-me with no webhook URL set exits with status 1" 1
assert_stderr_contains "spock-me with no webhook URL set names the variable to set" \
  "SPOCK_TELEGRAM_MESSAGE_WEBHOOK_URL is not set"

start_webhook
run_spock_me SPOCK_TELEGRAM_MESSAGE_WEBHOOK_AUTH_HEADER= -- "deploy finished"
assert_status "spock-me with no auth header set exits with status 1" 1
assert_stderr_contains "spock-me with no auth header set names the variable to set" \
  "SPOCK_TELEGRAM_MESSAGE_WEBHOOK_AUTH_HEADER is not set"

# n8n answers a header that does not match its credential with 403.
start_webhook
run_spock_me SPOCK_TELEGRAM_MESSAGE_WEBHOOK_AUTH_HEADER="$fake_header_name: wrong-value" \
  -- "deploy finished"
assert_status "spock-me whose auth header Spock rejects exits with status 1" 1
assert_stderr_contains "spock-me whose auth header Spock rejects reports the HTTP status" \
  "Spock refused the message (HTTP 403)"

stop_webhook

if (( failures > 0 )); then
  print -r -- ""
  print -r -- "$failures assertion(s) failed"
  exit 1
fi

print -r -- ""
print -r -- "all assertions passed"
