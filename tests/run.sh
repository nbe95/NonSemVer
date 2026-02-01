#!/bin/bash

dir="$(dirname "$0")"
NONSEMVER="$dir/../NonSemVer.sh"
export NONSEMVER

source "$dir/util/assert/assert.sh"

set +e   # Don't die on intentional errors
for file in "$dir"/*.test.sh; do
   source "$file"
done
