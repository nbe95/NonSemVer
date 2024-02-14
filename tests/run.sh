#!/bin/bash

dir="$(dirname "$0")"
NONSEMVER="$dir/../NonSemVer.sh"
export NONSEMVER

source "$dir/assert/assert.sh"

# Run all unit test files
for file in "$dir"/test*.sh; do
   source "$file"
done
