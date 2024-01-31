#!/bin/bash

dir="$(dirname "$0")"
NONSEMVER="$dir/../NonSemVer.sh"
export NONSEMVER

source "$dir/assert/assert.sh"


# Run separate unit tests
source "$dir/test-git.sh"
source "$dir/test-args.sh"
source "$dir/test-parse.sh"
source "$dir/test-bump.sh"
