#!/usr/bin/env bash

set -euo pipefail

export LANG=C
export LC_ALL=C

color_echo() {
    printf '\033[1;32m%s\033[0m\n' "$1"
}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
BUILD_DIR="$SCRIPT_DIR/${BUILD_DIR:-build}"
CLASSES_DIR="$BUILD_DIR/classes"
SERVER_PATH="$BUILD_DIR/droidgate-server"
APP_JAR="$BUILD_DIR/droidgate-classes.jar"
DEX_ZIP="$BUILD_DIR/droidgate-dex.zip"

ANDROID_PLATFORM=${ANDROID_PLATFORM:-35}
ANDROID_BUILD_TOOLS=${ANDROID_BUILD_TOOLS:-36.1.0}

if [ -z "${ANDROID_HOME:-}" ]; then
    echo "ANDROID_HOME is not set." >&2
    exit 1
fi

if [ -z "${JAVA_HOME:-}" ]; then
    if [ -x /usr/libexec/java_home ]; then
        JAVA_HOME=$(/usr/libexec/java_home -v 17)
    else
        echo "JAVA_HOME is not set." >&2
        exit 1
    fi
fi

JAVAC="$JAVA_HOME/bin/javac"
JAR="$JAVA_HOME/bin/jar"
BUILD_TOOLS_DIR="$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS"
D8="$BUILD_TOOLS_DIR/d8"
ANDROID_JAR="$ANDROID_HOME/platforms/android-$ANDROID_PLATFORM/android.jar"
LAMBDA_JAR="$BUILD_TOOLS_DIR/core-lambda-stubs.jar"
NANOHTTPD_JAR="$PROJECT_DIR/droidgate-core/libs/nanohttpd-2.3.1.jar"

for required_file in "$JAVAC" "$JAR" "$D8" "$ANDROID_JAR" "$LAMBDA_JAR" "$NANOHTTPD_JAR"; do
    if [ ! -f "$required_file" ]; then
        echo "Missing build dependency: $required_file" >&2
        exit 1
    fi
done

SOURCE_DIRS=(
    "$PROJECT_DIR/droidgate-core/src/main/java"
    "$PROJECT_DIR/droidgate-hidden-api/src/main/java"
    "$PROJECT_DIR/droidgate-plugins/src/main/java"
    "$PROJECT_DIR/droidgate-bundle/src/main/java"
)

SOURCES=()
while IFS= read -r source_file; do
    SOURCES+=("$source_file")
done < <(find "${SOURCE_DIRS[@]}" -type f -name '*.java' -print | sort)

if [ "${#SOURCES[@]}" -eq 0 ]; then
    echo "No public Java sources were found." >&2
    exit 1
fi

rm -rf "$CLASSES_DIR"
rm -f "$SERVER_PATH" "$APP_JAR" "$DEX_ZIP"
mkdir -p "$CLASSES_DIR"

color_echo "Compiling public Java sources..."
"$JAVAC" \
    -J-Duser.language=en \
    -J-Duser.country=US \
    -encoding UTF-8 \
    -source 8 \
    -target 8 \
    -bootclasspath "$ANDROID_JAR" \
    -classpath "$LAMBDA_JAR:$NANOHTTPD_JAR" \
    -d "$CLASSES_DIR" \
    "${SOURCES[@]}"

color_echo "Dexing public server..."
"$JAR" cf "$APP_JAR" -C "$CLASSES_DIR" com
"$D8" \
    --classpath "$ANDROID_JAR" \
    --output "$DEX_ZIP" \
    "$APP_JAR" \
    "$NANOHTTPD_JAR"

mv "$DEX_ZIP" "$SERVER_PATH"
rm -f "$APP_JAR"

echo "DroidGate server generated in $SERVER_PATH"
