#!/usr/bin/env bash

set -eu

if [[ "$#" -lt 2 ]]; then
  echo "Usage: $0 {Xcode|Pod} [Test type specific parameters]"
  exit 10
fi

readonly TEST_TYPE="$1"
shift

case "${TEST_TYPE}" in
  Xcode)
    exec Tests/xcode_tests.sh "$@"
    ;;
  SwiftPM)
    exec Tests/swiftpm_tests.sh "$@"
    ;;
  Pod)
    exec Tests/pod_integration_tests.sh "$@"
    ;;
  *)
    echo "Unknown TEST_TYPE: ${TEST_TYPE}"
    exit 11
    ;;
esac
