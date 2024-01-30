#!/bin/bash

DIR="$(dirname "$0")"
NONSEMVER="$DIR/../NonSemVer.sh"

# shellcheck disable=SC1091
source "$DIR/assert/assert.sh"

# Prepare current, next and previous year as variables
CY="$(date +"%y")"
NY=$((CY + 1))
PY=$((CY - 1))

# Run separate unit tests
source "$DIR/test-git.sh"
source "$DIR/test-args.sh"
source "$DIR/test-parse.sh"
source "$DIR/test-bump.sh"
