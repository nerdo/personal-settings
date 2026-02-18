#!/bin/bash
# PostToolUse hook: remind Claude to update KEYMAP.md when keymap source files change.

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('file_path', ''))
" 2>/dev/null)

# Skip if we can't determine the file path
[ -z "$FILE_PATH" ] && exit 0

# Skip KEYMAP.md itself to avoid infinite loops
[[ "$FILE_PATH" == *"KEYMAP.md" ]] && exit 0

# Trigger for lua files under lua/nerdo/
if [[ "$FILE_PATH" == *"/lua/nerdo/"*".lua" ]]; then
  echo "Keymap source file changed. Run /update-keymap to regenerate KEYMAP.md."
fi

exit 0
