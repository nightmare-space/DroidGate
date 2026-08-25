#!/usr/bin/env bash

set -euo pipefail

export LANG=C
export LC_ALL=C

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SERIAL=${1:-}

if [ -n "$SERIAL" ]; then
    export ANDROID_SERIAL="$SERIAL"
    echo "Using device: $SERIAL"
fi

"$SCRIPT_DIR/build_without_gradle.sh"

SERVER_PATH="$SCRIPT_DIR/build/droidgate-server"
if [ ! -f "$SERVER_PATH" ]; then
    echo "Build output not found: $SERVER_PATH" >&2
    exit 1
fi

SERVER_HASH=$(shasum -a 256 "$SERVER_PATH" | cut -c 1-8)
TARGET_SERVER_PATH="/data/local/tmp/droidgate-server-$SERVER_HASH"

RUNNING_PIDS=$(adb shell pidof droidgate | tr -d '\r' || true)
if [ -n "$RUNNING_PIDS" ]; then
    echo "Stopping existing DroidGate processes: $RUNNING_PIDS"
    adb shell "kill -9 $RUNNING_PIDS"
fi

echo "Pushing DroidGate server to: $TARGET_SERVER_PATH"
adb shell 'rm -f /data/local/tmp/droidgate-server-*'
adb push "$SERVER_PATH" "$TARGET_SERVER_PATH"

"$SCRIPT_DIR/forward_port.sh"

COMMAND="app_process -Djava.class.path=$TARGET_SERVER_PATH /system/bin --nice-name=droidgate com.nightmare.droidgate.DroidGate"
echo "Starting DroidGate with: $COMMAND"
adb shell "$COMMAND"
