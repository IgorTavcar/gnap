#!/usr/bin/env bash
# GNAP lightweight poller — runs every N minutes via system cron
# If new tasks/messages found → wakes the OpenClaw agent
# If nothing new → exits silently (zero LLM cost)
#
# Usage: gnap-poll.sh <agent-id> <hq-dir> [wake-command]
#
# Example crontab:
#   */5 * * * * /path/to/gnap-poll.sh carl /tmp/farol-hq "openclaw wake"
#
# The wake command can be:
#   - "openclaw wake"           → OpenClaw CLI wake
#   - "curl -X POST http://..."  → webhook
#   - "echo 'wake' > /tmp/wake"  → file-based signal

set -euo pipefail

AGENT="${1:?Usage: gnap-poll.sh <agent-id> <hq-dir> [wake-command]}"
HQ_DIR="${2:?}"
WAKE_CMD="${3:-echo WAKE}"
STATE_FILE="${HQ_DIR}/.gnap-poll-state-${AGENT}"

cd "$HQ_DIR"

# Pull latest
git pull --rebase --quiet 2>/dev/null || true

# Count ready tasks assigned to me
READY_TASKS=$(find .gnap/tasks/ -name "*.json" -exec python3 -c "
import json,sys
t = json.load(open(sys.argv[1]))
if '$AGENT' in t.get('assigned_to', []) and t.get('state') == 'ready':
    print(t['id'])
" {} \; 2>/dev/null | wc -l)

# Count unread messages for me
UNREAD_MSGS=$(find .gnap/messages/ -name "*.json" -exec python3 -c "
import json,sys
m = json.load(open(sys.argv[1]))
to = m.get('to', [])
read_by = m.get('read_by', [])
if ('$AGENT' in to or 'all' in to) and '$AGENT' not in read_by:
    print(m['id'])
" {} \; 2>/dev/null | wc -l)

# Build current state fingerprint
CURRENT="${READY_TASKS}:${UNREAD_MSGS}"

# Compare with last known state
PREVIOUS=""
[ -f "$STATE_FILE" ] && PREVIOUS=$(cat "$STATE_FILE")

if [ "$CURRENT" != "$PREVIOUS" ] && [ "$READY_TASKS" -gt 0 ] || [ "$UNREAD_MSGS" -gt 0 ]; then
    # Something new — wake the agent
    echo "[$(date -u +%H:%M)] gnap-poll: ${AGENT} has ${READY_TASKS} ready tasks, ${UNREAD_MSGS} unread msgs → WAKE"
    eval "$WAKE_CMD"
    echo "$CURRENT" > "$STATE_FILE"
else
    # Nothing new — stay quiet
    :
fi
