#!/bin/bash

# Check if version can be retreived from latest Git tag
git -C "$DIR" tag -a "99.42.69" -m "Created during unit test" &> /dev/null
assert_eq "$($NONSEMVER)" "99.42.0069" "Git tag"
git -C "$DIR" tag -d "99.42.69" &> /dev/null
