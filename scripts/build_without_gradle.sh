#!/usr/bin/env bash
#
# This script generates the scrcpy binary "manually" (without gradle).
#
# Adapt Android platform and build tools versions (via ANDROID_PLATFORM and
# ANDROID_BUILD_TOOLS environment variables).
#
# Then execute:
#
#     BUILD_DIR=my_build_dir ./build_without_gradle.sh
function color_echo()
{
    echo -e "\033[1;32m$1\033[0m"
}
JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
JAVAC="$JAVA_HOME/bin/javac"
set -e
LOCAL_DIR=$(cd `dirname $0`; pwd)
PROJ_DIR=$(cd $LOCAL_DIR/..; pwd)
unset ANDROID_PLATFORM
unset ANDROID_BUILD_TOOLS
PLATFORM=${ANDROID_PLATFORM:-35}
BUILD_TOOLS=${ANDROID_BUILD_TOOLS:-36.1.0}
BUILD_TOOLS_DIR="$ANDROID_HOME/build-tools/$BUILD_TOOLS"
# BUILD_DIR="$(realpath ${BUILD_DIR:-build})"
BUILD_DIR="$LOCAL_DIR/${BUILD_DIR:-build}"
GEN_DIR="$BUILD_DIR/gen"
CLASSES_DIR="$BUILD_DIR/classes"
HIDDEN_API_MODULE=$PROJ_DIR/droidgate-hidden-api
SERVER_BINARY=droidgate-server
ANDROID_JAR="$ANDROID_HOME/platforms/android-$PLATFORM/android.jar"
LAMBDA_JAR="$BUILD_TOOLS_DIR/core-lambda-stubs.jar"
printf "%-20s %-20s\n" "Variable" "Value"
printf "%-20s %-20s\n" "--------" "-----"
printf "%-20s %-20s\n" "PLATFORM" "$PLATFORM"
printf "%-20s %-20s\n" "PROJ_DIR" "$PROJ_DIR"
printf "%-20s %-20s\n" "ANDROID_HOME" "$ANDROID_HOME"
printf "%-20s %-20s\n" "BUILD_DIR" "${BUILD_DIR}"
printf "%-20s %-20s\n" "CLASSES_DIR" "$CLASSES_DIR"
printf "%-20s %-20s\n" "LOCAL_DIR" "$LOCAL_DIR"
printf "%-20s %-20s\n" "Platform:" "android-$PLATFORM"
printf "%-20s %-20s\n" "Build-tools:" "$BUILD_TOOLS"
printf "%-20s %-20s\n" "BUILD_TOOLS_DIR" "$BUILD_TOOLS_DIR"
printf "%-20s %-20s\n" "GEN_DIR" "$GEN_DIR"

# rm -rf "$CLASSES_DIR" "$BUILD_DIR/$SERVER_BINARY" classes.dex

mkdir -p "$CLASSES_DIR/com/nightmare/droidgate"

color_echo "Generating java from aidl..."
cd "$HIDDEN_API_MODULE/src/main/aidl"
# "$BUILD_TOOLS_DIR/aidl" -o"$GEN_DIR" -I. android/app/ITaskStackListener.aidl
"$BUILD_TOOLS_DIR/aidl" -o"$GEN_DIR" -I. android/view/IRotationWatcher.aidl

# cd $PROJ_DIR/src/main/java
DROIDGATE_BUNDLE_DIR=$PROJ_DIR/droidgate-bundle
DROIDGATE_BUNDLE_SRC_DIR=$DROIDGATE_BUNDLE_DIR/src/main/java
HIDDEN_API_DIR=$HIDDEN_API_MODULE/src/main/java
DROIDGATE_CORE_SRC_DIR=$PROJ_DIR/droidgate-core/src/main/java
DROIDGATE_PLUGINS_SRC_DIR=$PROJ_DIR/droidgate-plugins/src/main/java

SRC=( \
    $DROIDGATE_CORE_SRC_DIR/com/nightmare/droidgate/*.java \
    $DROIDGATE_CORE_SRC_DIR/com/nightmare/droidgate/foundation/*.java \
    $DROIDGATE_CORE_SRC_DIR/com/nightmare/droidgate/helper/*.java \
    $DROIDGATE_PLUGINS_SRC_DIR/com/nightmare/droidgate/plugins/*.java \
    $DROIDGATE_PLUGINS_SRC_DIR/com/nightmare/droidgate/plugins/helper/*.java \
    $DROIDGATE_BUNDLE_SRC_DIR/com/nightmare/droidgate/*.java \
)

HIDDEN=( \
    $HIDDEN_API_DIR/android/os/*.java \
    $HIDDEN_API_DIR/android/app/*.java \
    $HIDDEN_API_DIR/android/content/pm/*.java \
    $HIDDEN_API_DIR/android/window/*.java \
    $HIDDEN_API_DIR/android/graphics/*.java \
    $HIDDEN_API_DIR/android/hardware/display/*.java \
    $HIDDEN_API_DIR/android/hardware/input/*.java \
    $HIDDEN_API_DIR/android/ddm/*.java \
    $HIDDEN_API_DIR/android/view/*.java \
    $HIDDEN_API_DIR/com/android/internal/os/*.java \
)

color_echo "Compiling native library..."

"$LOCAL_DIR/build_lib.sh"

color_echo "Compiling java sources..."

JAR_PATH=$PROJ_DIR/droidgate-core/libs

"$JAVAC" -encoding UTF-8 -bootclasspath "$ANDROID_JAR" \
    -Djava.ext.dirs=$JAR_PATH \
    -cp "$LAMBDA_JAR:$GEN_DIR:$JAR_PATH/nanohttpd-2.3.1.jar" \
    -d "$CLASSES_DIR" \
    -source 1.8 -target 1.8 \
    ${HIDDEN[@]} \
    ${SRC[@]}

cp -r $PROJ_DIR/fi $CLASSES_DIR/
color_echo "Dexing..."
cd "$CLASSES_DIR"

CLASSES=(
    com/nightmare/droidgate/*.class
    com/nightmare/droidgate/foundation/*.class
    com/nightmare/droidgate/helper/*.class
    com/nightmare/droidgate/plugins/*.class
    com/nightmare/droidgate/plugins/helper/*.class
)

if [[ $PLATFORM -lt 31 ]]
then
    # use dx
    color_echo "Dexing with dx..."
    "$BUILD_TOOLS_DIR/dx" --dex --output "$BUILD_DIR/classes.dex" \
        "${CLASSES[@]}" \
        android/content/pm/*.class \
        android/os/*.class \
        android/hardware/display/*.class \
        android/hardware/input/*.class \
        android/graphics/*.class \
        android/app/*.class \
        android/window/*.class \
        android/ddm/*.class \
        androidx/annotation/*.class \
        fi/iki/elonen/*.class \
        fi/iki/elonen/util/*.class

    echo "Archiving..."
    cd "$BUILD_DIR"
    jar cvf "$SERVER_BINARY" classes.dex
    rm -rf classes.dex
else
    color_echo "Dexing with d8..."
    # use d8
    "$BUILD_TOOLS_DIR/d8" --classpath "$ANDROID_JAR" \
        --output "$BUILD_DIR/classes.zip" \
        "${CLASSES[@]}" \
        fi/iki/elonen/*.class \
        fi/iki/elonen/util/*.class

    cd "$BUILD_DIR"
    mv classes.zip "$SERVER_BINARY"
fi

cd "$BUILD_DIR"

if [ ! -f "libdroidgate.so" ]; then
    echo "Missing libdroidgate.so"
    exit 1
fi

"$JAVA_HOME/bin/jar" uf "$SERVER_BINARY" libdroidgate.so

# rm -rf classes.dex classes gen

echo "DroidGate server generated in $BUILD_DIR/$SERVER_BINARY"
