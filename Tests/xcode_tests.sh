#!/usr/bin/env bash

set -eu

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 {iOS|OSX|tvOS} {Debug|Release|Both}"
  exit 10
fi

readonly BUILD_MODE="$1"
readonly BUILD_CFG="$2"

# Default to "test", changed via BUILD_MODE below.
XCODEBUILD_ACTION="test"

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
    ;;
  OSXCore)
    CMD_BUILDER+=(
      -project Source/GTLRCore.xcodeproj
      -scheme "OS X Framework and Tests"
    )
    ;;
  tvOSCore)
    CMD_BUILDER+=(
      -project Source/GTLRCore.xcodeproj
      -scheme "tvOS Framework and Tests"
      -destination "platform=tvOS Simulator,name=Apple TV 1080p,OS=latest"
    )
    ;;
  watchOSCore)
    CMD_BUILDER+=(
      -project Source/GTLRCore.xcodeproj
      -scheme "watchOS Framework"
    )
    XCODEBUILD_ACTION="build"
    ;;
  ServiceGenerator)
    CMD_BUILDER+=(
      -project "Source/Tools/ServiceGenerator/ServiceGenerator.xcodeproj"
      -scheme "ServiceGenerator"
    )
    XCODEBUILD_ACTION="build"
    ;;
  Example_*)
    EXAMPLE_NAME="${BUILD_MODE/Example_/}"
    (cd "Examples/${EXAMPLE_NAME}" && pod install)
    CMD_BUILDER+=(
      -workspace "Examples/${EXAMPLE_NAME}/${EXAMPLE_NAME}.xcworkspace"
      -scheme "${EXAMPLE_NAME}"
    )
    XCODEBUILD_ACTION="build"
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
