#!/usr/bin/env bash

set -eu

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 {ios|tvos|osx} {Debug|Release|Both}"
  exit 10
fi

readonly PLATFORM="$1"
readonly BUILD_CFG="$2"

# Report then run the build
RunXcodeBuild() {
  echo xcodebuild "$@"
  # If xcpretty is installed, use it to cut down on the output length.
  if hash xcpretty >/dev/null 2>&1 ; then
    set -o pipefail && xcodebuild "$@" | xcpretty
  else
    xcodebuild "$@"
  fi
}

# DEPLOYMENT_TARGET should be kept in sync with the podspec deployment
# targets.
case "${PLATFORM}" in
  ios)
    TARGET_NAME=iOSPodTests
    DEPLOYMENT_TARGET=9.0
    SDK=iphonesimulator
    ;;
  osx)
    TARGET_NAME=macOSPodTests
    DEPLOYMENT_TARGET=10.9
    SDK=macosx
    ;;
  tvos)
    TARGET_NAME=tvOSPodTests
    DEPLOYMENT_TARGET=9.0
    SDK=appletvsimulator
    ;;
  *)
    echo "Unknown PLATFORM: ${PLATFORM}"
    exit 12
    ;;
esac

# Create temporary folders for working with pod and xcodebuild.
readonly WORKING_DIR="$(mktemp -d "${TMPDIR}/gtlr_subspecs_XXXXXX")"
readonly DERIVED_DATA="$(mktemp -d "${WORKING_DIR}/derived_data_XXXXXX")"
trap 'rm -rf "$WORKING_DIR"' ERR EXIT

# Create a Podfile in the temp directory that references all available
# GeneratedServices.
readonly PODFILE="$WORKING_DIR/Podfile"

#Copy the project file so as not to tamper with the original project.
cp -rf "$(PWD)/Tests/PodTests.xcodeproj" "$WORKING_DIR/PodTests.xcodeproj"
cp -rf "$(PWD)/Tests/$TARGET_NAME" "$WORKING_DIR/$TARGET_NAME"

cat > "$PODFILE" << EOF
target '$TARGET_NAME' do
  platform :$PLATFORM, '$DEPLOYMENT_TARGET'
EOF

for service in Source/GeneratedServices/*; do
  cat >> "$PODFILE" << EOF
  pod 'GoogleAPIClientForREST/${service##*/}', :path => '$(PWD)'
EOF
done

cat >> "$PODFILE" << EOF
end
EOF

# Dive into the working directory and build the project using
# pod and xcodebuild.
cd "$WORKING_DIR"
pod install

readonly CMD_BUILDER=(
  GCC_TREAT_WARNINGS_AS_ERRORS=YES
  -workspace PodTests.xcworkspace
  -scheme "$TARGET_NAME"
  -sdk "$SDK"
  -derivedDataPath "$DERIVED_DATA"
)

case "${BUILD_CFG}" in
  Debug|Release)
    RunXcodeBuild "${CMD_BUILDER[@]}" -configuration "${BUILD_CFG}"
    ;;
  Both)
    RunXcodeBuild "${CMD_BUILDER[@]}" -configuration Debug
    RunXcodeBuild "${CMD_BUILDER[@]}" -configuration Release
    ;;
  *)
    echo "Unknown BUILD_CFG: ${BUILD_CFG}"
    exit 12
    ;;
esac
