#!/bin/bash

# Abort on error
set -e

# shellcheck disable=SC2001
trim_leading_zeros() { echo "$1" | sed 's/^0\+\(.\)/\1/'; }
usage() { echo "Usage: $(basename "$0") [-h|--help] [-v|--verbose] [-i|--integer] [--major|--minor] [VERSION]" 1>&2; exit 0; }

# Parse argument options
VERBOSE=false
INTEGER=false
BUMP_MAJOR=false
BUMP_MINOR=false
while true; do
  case "$1" in
    -h | --help ) usage ;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -i | --integer ) INTEGER=true; shift ;;
    --major ) BUMP_MAJOR=true; shift ;;
    --minor ) BUMP_MINOR=true; shift ;;
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
    year="$(trim_leading_zeros "${BASH_REMATCH[2]}")"
    majmin="$(trim_leading_zeros "${BASH_REMATCH[3]}")"

else
    # Match an integer else (pad with zeros and replace anything but numbers)
    if [[ ! "$version" =~ ^[0-9]{1,8}$ ]]; then
        echo "Version tag '$version' has invalid format."
        exit 2
    fi
    # shellcheck disable=SC2001
    version="$(echo "$version" | sed 's/[^0-9]//g')"
    printf -v version "%08d" "$(trim_leading_zeros "$version")"

    prefix="$(trim_leading_zeros "${version:0:2}")"
    year="$(trim_leading_zeros "${version:2:2}")"
    majmin="$(trim_leading_zeros "${version:4:4}")"
fi

# Parse remaining components
major=$((majmin / 100))
minor=$((majmin % 100))

# Perform version bump if requested
if $BUMP_MAJOR || $BUMP_MINOR; then
    current_year="$(date +"%y")"
    if [[ "$year" < "$current_year" ]]; then
        # Year has changed -> reset all
        year="$current_year"
        major=1
        minor=0
    elif $BUMP_MAJOR; then
        # Bump major, reset minor
        major="$((major + 1))"
        minor=0
    else
        # Bump minor
        minor="$((minor + 1))"
    fi
fi

if [ "$major" -gt 99 ] || [ "$minor" -gt 99 ]; then
    echo "Cannot bump version number, because numerical limit is reached."
    exit 3
fi

# Output parsed version
if $INTEGER; then
    printf -v output "%02d%02d%02d%02d\n" "$prefix" "$year" "$major" "$minor"
    trim_leading_zeros "$output"
else
    printf "%02d.%02d.%02d%02d\n" "$prefix" "$year" "$major" "$minor"
fi

# Verbose output
if $VERBOSE; then
    echo ""
    printf "Project ID:\t\t%d\n" "$prefix"
    printf "Deployment year:\t20%02d\n" "$year"
    printf "Major version:\t\t%d\n" "$major"
    printf "Minor version:\t\t%d\n" "$minor"
fi
