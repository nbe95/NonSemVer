#!/bin/bash

set -x

dir="$(dirname "$0")"
NONSEMVER="$dir/../NonSemVer.sh"
export NONSEMVER

source "$dir/util/assert/assert.sh"

# Run all unit test files
set -e
for file in "$dir"/*.test.sh; do
   source "$file"
done
