#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VERSION="${1:-v1.0.0}"
GRADLEW="$PROJECT_DIR/gradlew"

if [[ ! -x "$GRADLEW" ]]; then
    echo "DroidGate Gradle wrapper not found: $GRADLEW" >&2
    echo "Usage: $0 [version]" >&2
    exit 1
fi

"$GRADLEW" \
    -p "$PROJECT_DIR" \
    -PpublishVersion="$VERSION" \
    :droidgate-hidden-api:publishReleasePublicationToMavenLocal \
    :droidgate-core:publishReleasePublicationToMavenLocal \
    :droidgate-plugins:publishReleasePublicationToMavenLocal \
    :droidgate-bundle:publishReleasePublicationToMavenLocal

echo "Published com.github.nightmare-space.DroidGate artifacts $VERSION to ~/.m2/repository."
