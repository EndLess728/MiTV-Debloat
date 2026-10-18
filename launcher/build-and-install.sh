#!/usr/bin/env bash
# Build the launcher APK and install it on the TV as the default home screen.
set -euo pipefail
cd "$(dirname "$0")"
: "${TV_HOST:?set TV_HOST to the TV IP address, e.g. TV_HOST=192.168.0.120 $0}"
STOCK_LAUNCHER="${STOCK_LAUNCHER:-com.google.android.tvlauncher}"
export JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 17 2>/dev/null || echo /opt/homebrew/opt/openjdk@17)}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export PATH="$JAVA_HOME/bin:$PATH"
[ -f local.properties ] || echo "sdk.dir=$ANDROID_HOME" > local.properties
./gradlew assembleDebug -q --console=plain
APK=app/build/outputs/apk/debug/app-debug.apk
SERIAL="$TV_HOST:${TV_PORT:-5555}"
if command -v adb >/dev/null && adb connect "$SERIAL" >/dev/null 2>&1 && adb -s "$SERIAL" get-state >/dev/null 2>&1; then
  adb -s "$SERIAL" push "$APK" /data/local/tmp/tvhome.apk
else
  ../tools/venv/bin/python -I ../tools/b64push.py "$APK" /data/local/tmp/tvhome.apk
fi
printf '%s\n' \
  "pm install -r /data/local/tmp/tvhome.apk" \
  "rm -f /data/local/tmp/tvhome.apk" \
  "pm grant com.gathin.tvhome android.permission.ACCESS_FINE_LOCATION 2>/dev/null; echo location-granted" \
  "cmd package set-home-activity --user 0 com.gathin.tvhome/.MainActivity" \
  "pm disable-user --user 0 $STOCK_LAUNCHER" \
  | ../tools/tvbatch.sh
echo "Installed. Press Home on the remote to see it."
