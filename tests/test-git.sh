#!/bin/bash


# Check if version can be retrieved from latest Git tag
git_dir="$(dirname "$0")"
git -C "$git_dir" tag -a "99.42.69" -m "Created during unit test" &> /dev/null
assert_eq "$($NONSEMVER)" "99.42.0069" "Git tag"
git -C "$git_dir" tag -d "99.42.69" &> /dev/null
