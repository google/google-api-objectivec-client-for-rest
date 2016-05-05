#!/usr/bin/env bash

set -eu

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 {iOS|OSX} {Debug|Release}"
  exit 10
fi

readonly BUILD_MODE="$1"
readonly BUILD_CFG="$2"

# Default to "build", based on BUILD_MODE below.
XCODEBUILD_ACTION="build"

# Report then run the build
RunXcodeBuild() {
  echo xcodebuild "$@"
  xcodebuild "$@"
}

case "${BUILD_MODE}" in
  iOSCore)
    CMD_BUILDER+=(
      -project Source/GTLRCore.xcodeproj
      -scheme "iOS Framework and Tests"
      -destination "platform=iOS Simulator,name=iPhone 6,OS=latest"
    )
    XCODEBUILD_ACTION="test"
    ;;
  OSXCore)
    CMD_BUILDER+=(
      -project Source/GTLRCore.xcodeproj
      -scheme "OS X Framework and Tests"
    )
    XCODEBUILD_ACTION="test"
    ;;
  Example_*)
    EXAMPLE_NAME="${BUILD_MODE/Example_/}"
    CMD_BUILDER+=(
      -project "Examples/${EXAMPLE_NAME}/${EXAMPLE_NAME}.xcodeproj"
      -scheme "${EXAMPLE_NAME}"
    )
    ;;
  *)
    echo "Unknown BUILD_MODE: ${BUILD_MODE}"
    exit 11
    ;;
esac

case "${BUILD_CFG}" in
  Debug|Release)
    RunXcodeBuild "${CMD_BUILDER[@]}" -configuration "${BUILD_CFG}" "${XCODEBUILD_ACTION}"
    ;;
  Both)
    RunXcodeBuild "${CMD_BUILDER[@]}" -configuration Debug "${XCODEBUILD_ACTION}"
    RunXcodeBuild "${CMD_BUILDER[@]}" -configuration Release "${XCODEBUILD_ACTION}"
    ;;
  *)
    echo "Unknown BUILD_CFG: ${BUILD_CFG}"
    exit 12
    ;;
esac
