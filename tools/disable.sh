#!/usr/bin/env bash
# Disable every package listed in a debloat file on the TV (one package per line, # comments allowed).
# Packages are disabled for user 0, never uninstalled. Undo with tools/restore.sh <same file>.
#
# Usage: TV_HOST=192.168.0.120 tools/disable.sh examples/xiaomi-mitv-axso0/debloat.txt
set -euo pipefail
cd "$(dirname "$0")/.."
LIST="${1:?usage: disable.sh <debloat list>}"
{
  grep -vE '^[[:space:]]*(#|$)' "$LIST" | awk '{print "pm disable-user --user 0 " $1}'
  echo "pm list packages -d"
} | tools/tvbatch.sh
