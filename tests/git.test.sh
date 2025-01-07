#!/bin/bash


# Delete existing test tag
git tag -d "99.42.69" || true

# Check if version can be retrieved from latest Git tag
git tag -a "99.42.69" -m "Created during unit test"
assert_eq "$($CMD)" "99.42.0069" "Git tag"

# Tidy up
git tag -d "99.42.69" || true
