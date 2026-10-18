#!/usr/bin/env bash
# Run shell commands on the TV, one per stdin line, each as its own shell call (chained pm commands
# can silently stop after the first). Uses the stock adb when it can reach the TV, otherwise the
# pure-Python client in tools/tv.py (for macOS setups where Local Network privacy blocks adb).
#
# Usage: printf 'cmd1\ncmd2\n' | TV_HOST=192.168.0.120 tools/tvbatch.sh
set -euo pipefail
cd "$(dirname "$0")/.."
: "${TV_HOST:?set TV_HOST to the TV IP address, e.g. TV_HOST=192.168.0.120}"
SERIAL="$TV_HOST:${TV_PORT:-5555}"
if command -v adb >/dev/null && adb connect "$SERIAL" >/dev/null 2>&1 && adb -s "$SERIAL" get-state >/dev/null 2>&1; then
  while IFS= read -r line; do
    [[ -z "${line// }" || "$line" == \#* ]] && continue
    echo "\$ $line"
    adb -s "$SERIAL" shell "$line" </dev/null || true
  done
else
  PY=tools/venv/bin/python
  [ -x "$PY" ] || { echo "adb can't reach $SERIAL; run: python3 -m venv tools/venv && tools/venv/bin/pip install -r tools/requirements.txt"; exit 1; }
  "$PY" -I tools/tv.py --batch
fi
