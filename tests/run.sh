#!/bin/bash

# Abort on any error, e.g. assertions
set -e

dir="$(dirname "$0")"
NONSEMVER="$dir/../NonSemVer.sh"
export NONSEMVER

source "$dir/util/assert/assert.sh"

for file in "$dir"/*.test.sh; do
   source "$file"
done
