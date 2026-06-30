#!/bin/bash

# A generic retry script that runs a command and retries it if it fails
# and the output matches a specific pattern.

set -eu
set -o pipefail

MAX_RETRIES=1
PATTERN="Unable to find a device matching the provided destination specifier"
DELAY=10

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-retries)
      MAX_RETRIES="$2"
      shift 2
      ;;
    --pattern)
      PATTERN="$2"
      shift 2
      ;;
    --delay)
      DELAY="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [ $# -eq 0 ]; then
  echo "Usage: $0 [--max-retries N] [--pattern PATTERN] [--delay SECONDS] -- COMMAND [ARGS...]"
  exit 1
fi

if [ -z "$PATTERN" ]; then
  echo "Error: A non-empty pattern is required to identify transient failures." >&2
  exit 1
fi

COMMAND=("$@")

ATTEMPT=0
MAX_ATTEMPTS=$((MAX_RETRIES + 1))

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT + 1))
  if [ $ATTEMPT -gt 1 ]; then
    echo "Attempt $ATTEMPT of $MAX_ATTEMPTS (Retry $((ATTEMPT - 1)) of $MAX_RETRIES)..."
  fi

  # We need to capture the output to check for the pattern, but also stream it.
  # We'll use a temp file for the log.
  LOG_FILE=$(mktemp)

  # Run the command
  set +e
  "${COMMAND[@]}" 2>&1 | tee "$LOG_FILE"
  STATUS=$?
  set -e

  if [ $STATUS -eq 0 ]; then
    rm -f "$LOG_FILE"
    exit 0
  fi

  # Check if the failure matches the required pattern.
  SHOULD_RETRY=false
  if grep -q "$PATTERN" "$LOG_FILE"; then
    echo "Warning: Command failed and output matched pattern: '$PATTERN'"
    SHOULD_RETRY=true
  fi

  rm -f "$LOG_FILE"

  if [ "$SHOULD_RETRY" = true ] && [ $ATTEMPT -lt $MAX_ATTEMPTS ]; then
    echo "Retrying in $DELAY seconds..."
    sleep "$DELAY"
  else
    exit $STATUS
  fi
done

