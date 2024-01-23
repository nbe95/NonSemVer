#!/bin/bash

# Abort on error
set -e

# Reusable functions
trim_leading_zeros() { echo "$1" | sed 's/^0\+\(.\)/\1/'; }

# Get version from CLI argument, otherwise ask git
version="$1"
if [[ -z "$version" ]]; then
    version="$(git -C "$(pwd)" describe --tags --abbrev=0 2> /dev/null || true)"
fi
if [[ -z "$version" ]]; then
    echo "No version tag available."
    exit 1
fi

# Try to match dot form
if [[ "$version" =~ ^([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,4})$ ]]; then
    prefix="$(trim_leading_zeros "${BASH_REMATCH[1]}")"
    cycle="$(trim_leading_zeros "${BASH_REMATCH[2]}")"
    majmin="$(trim_leading_zeros "${BASH_REMATCH[3]}")"

else
    # Match an integer else (pad with zeros and replace anything but numbers)
    if [[ ! "$version" =~ ^[0-9]{1,8}$ ]]; then
        echo "Version tag '$version' has invalid format."
        exit 2
    fi
    version="$(echo "$version" | sed 's/[^0-9]//g')"
    printf -v version "%08d" "$(trim_leading_zeros "$version")"

    prefix="$(trim_leading_zeros "${version:0:2}")"
    cycle="$(trim_leading_zeros "${version:2:2}")"
    majmin="$(trim_leading_zeros "${version:4:4}")"
fi

# Parse remaining components
major=$(($majmin / 100))
minor=$(($majmin % 100))

# Output parsed version
printf "%02d.%02d.%02d%02d\n" "$prefix" "$cycle" "$major" "$minor"

# Verbose output
echo ""
printf "Version prefix:\t\t%d\n" "$prefix"
printf "Cycle identifier:\t20%02d\n" "$cycle"
printf "Major component:\t%d\n" "$major"
printf "Minor component:\t%d\n" "$minor"
