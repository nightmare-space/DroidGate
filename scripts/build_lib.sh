#!/bin/bash
set -euo pipefail

LOCAL_DIR=$(
    cd "$(dirname "$0")"
    pwd
)

NDK_PATH="${ANDROID_NDK:-${ANDROID_HOME}/ndk/27.3.13750724}"
CPP_DIR="$LOCAL_DIR/../droidgate-core/src/main/cpp"
NATIVE_BUILD_DIR="$CPP_DIR/build"

cmake \
    -S "$CPP_DIR" \
    -B "$NATIVE_BUILD_DIR" \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$NDK_PATH/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-21

cmake --build "$NATIVE_BUILD_DIR"

mkdir -p "$LOCAL_DIR/build"
cp "$NATIVE_BUILD_DIR/libdroidgate.so" "$LOCAL_DIR/build/libdroidgate.so"