#!/usr/bin/env bash

set -eu

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 {iOS|OSX} {Debug|Release}"
  exit 10
fi

readonly BUILD_MODE="$1"
readonly BUILD_CFG="$2"

# Default to "build", based on BUILD_MODE below.
XCTOOL_ACTION="build"

# Report then run the build
RunXCTool() {
  echo xctool "$@"
  xctool "$@"
}

CMD_BUILDER=(
  # Always use -reporter plain to avoid escape codes in output (makes travis
  # logs easier to read).
  -reporter plain
)

case "${BUILD_MODE}" in
  iOSCore)
    CMD_BUILDER+=(
      -project Source/GTLRCore.xcodeproj
      -scheme "iOS Framework and Tests"
      -sdk iphonesimulator
    )
    XCTOOL_ACTION="test"
    ;;
  OSXCore)
    CMD_BUILDER+=(
      -project Source/GTLRCore.xcodeproj
      -scheme "OS X Framework and Tests"
    )
    XCTOOL_ACTION="test"
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
    RunXCTool "${CMD_BUILDER[@]}" -configuration "${BUILD_CFG}" "${XCTOOL_ACTION}"
    ;;
  Both)
    RunXCTool "${CMD_BUILDER[@]}" -configuration Debug "${XCTOOL_ACTION}"
    RunXCTool "${CMD_BUILDER[@]}" -configuration Release "${XCTOOL_ACTION}"
    ;;
  *)
    echo "Unknown BUILD_CFG: ${BUILD_CFG}"
    exit 12
    ;;
esac
