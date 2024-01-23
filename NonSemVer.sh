#!/bin/bash

# Abort on error
set -e

# Reusable functions
usage() { echo "Usage: $(basename "$0") [-h|--help] [-v|--verbose] [-i|--integer] [--major|--minor|--patch] [VERSION]" 1>&2; exit 0; }
trim_leading_zeros() { echo "$1" | sed 's/^0\+\(.\)/\1/'; }

# Parse argument options
VERBOSE=false
INTEGER=false
BUMP_MAJOR=false
BUMP_MINOR=false
BUMP_PATCH=false
while true; do
  case "$1" in
    -h | --help ) usage ;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -i | --integer ) INTEGER=true; shift ;;
    --major ) BUMP_MAJOR=true; shift ;;
    --minor ) BUMP_MINOR=true; shift ;;
    --patch ) BUMP_PATCH=true; shift ;;
    * ) break ;;
  esac
done

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
if $INTEGER; then
    out_format="%02d%02d%02d%02d\n"
else
    out_format="%02d.%02d.%02d%02d\n"
fi
printf "$out_format" "$prefix" "$cycle" "$major" "$minor"

# Verbose output
if $VERBOSE; then
    echo ""
    printf "Version prefix:\t\t%d\n" "$prefix"
    printf "Cycle identifier:\t20%02d\n" "$cycle"
    printf "Major component:\t%d\n" "$major"
    printf "Minor component:\t%d\n" "$minor"
fi
