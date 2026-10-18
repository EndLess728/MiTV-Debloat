#!/usr/bin/env bash
# Re-enable every package listed in a debloat file, restore the stock launcher as home and reset
# animation scales. Pass the same list you used with tools/disable.sh.
#
# Usage: TV_HOST=192.168.0.120 tools/restore.sh examples/xiaomi-mitv-axso0/debloat.txt [stock.launcher.package] [stock/.HomeActivity]
set -euo pipefail
cd "$(dirname "$0")/.."
LIST="${1:?usage: restore.sh <debloat list> [stock launcher package]}"
STOCK="${2:-com.google.android.tvlauncher}"
STOCK_HOME="${3:-$STOCK/.MainActivity}"   # Android 9 needs the full component
{
  grep -vE '^[[:space:]]*(#|$)' "$LIST" | awk '{print "pm enable " $1}'
  echo "pm enable $STOCK"
  echo "cmd package set-home-activity --user 0 $STOCK_HOME"
  echo "settings put global window_animation_scale 1.0"
  echo "settings put global transition_animation_scale 1.0"
  echo "settings put global animator_duration_scale 1.0"
  echo "pm list packages -d"
} | tools/tvbatch.sh
