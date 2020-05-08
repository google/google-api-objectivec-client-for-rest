#!/usr/bin/env bash

set -eu

if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 CI_MODE {Debug|Release|Both}"
  echo ""
  echo "CI_MODE is one of the modes for the CI setup"
  exit 10
fi

readonly TestsDir=$(dirname "$(echo $0 | sed -e "s,^\([^/]\),$(pwd)/\1,")")
readonly RootDir="${TestsDir}/.."

readonly BUILD_MODE="$1"
readonly BUILD_CFG="$2"

# Report then run the build
RunSwift() {
  echo "-------------------------------------------------------------------------------------"
  echo swift "$@"
  swift "$@"
}

CMD_MODES=("build" "test")
case "${BUILD_MODE}" in
  Lib)
    BUILD_DIR="${RootDir}"
    ;;
  ServiceGenerator)
    BUILD_DIR="${RootDir}/Source/Tools"
    # No tests.
    CMD_MODES=("build")
    ;;
  *)
    echo "Unknown BUILD_MODE: ${BUILD_MODE}"
    exit 11
    ;;
esac

declare -a CMD_CONFIGS
case "${BUILD_CFG}" in
  Debug|Release)
    CMD_CONFIGS+=("${BUILD_CFG}")
    ;;
  Both)
    CMD_CONFIGS+=("Debug" "Release")
    ;;
  *)
    echo "Unknown BUILD_CFG: ${BUILD_CFG}"
    exit 12
    ;;
esac

# Move to the right build directory
cd "${BUILD_DIR}"

# Loop over the command configs (Debug|Release)
for CMD_CONFIG in "${CMD_CONFIGS[@]}"; do
  LOWER_CMD_CONFIG="$(echo "${CMD_CONFIG}" | tr "[:upper:]" "[:lower:]")"
  # Loop over the command modes (build|test)
  for CMD_MODE in "${CMD_MODES[@]}"; do
    LOWER_CMD_MODE="$(echo "${CMD_MODE}" | tr "[:upper:]" "[:lower:]")"
    RunSwift "${LOWER_CMD_MODE}" --configuration "${LOWER_CMD_CONFIG}"
  done
done
