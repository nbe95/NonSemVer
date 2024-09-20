#!/bin/bash

# Abort on error
set -e

# shellcheck disable=SC2001
trim_leading_zeros() { echo "$1" | sed 's/^0\+\(.\)/\1/'; }
usage() { echo "Usage: $(basename "$0") [-h|--help] [-v|--verbose] [-i|--integer] [--bump-minor|--bump-patch] [VERSION]" 1>&2; exit 0; }

# Parse argument options
VERBOSE=false
INTEGER=false
BUMP_MINOR=false
BUMP_PATCH=false
while true; do
  case "$1" in
    -h | --help ) usage ;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -i | --integer ) INTEGER=true; shift ;;
    --bump-minor ) BUMP_MINOR=true; shift ;;
    --bump-patch ) BUMP_PATCH=true; shift ;;
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
if [[ "$version" =~ ^v?([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,4})$ ]]; then
    prefix="$(trim_leading_zeros "${BASH_REMATCH[1]}")"
    major="$(trim_leading_zeros "${BASH_REMATCH[2]}")"
    minor_patch="$(trim_leading_zeros "${BASH_REMATCH[3]}")"

else
    # Match an integer else (pad with zeros and replace anything but numbers)
    if [[ ! "$version" =~ ^v?[0-9]{1,8}$ ]]; then
        echo "Version tag '$version' has invalid format."
        exit 2
    fi
    # shellcheck disable=SC2001
    version="$(echo "$version" | sed 's/[^0-9]//g')"
    printf -v version "%08d" "$(trim_leading_zeros "$version")"

    prefix="$(trim_leading_zeros "${version:0:2}")"
    major="$(trim_leading_zeros "${version:2:2}")"
    minor_patch="$(trim_leading_zeros "${version:4:4}")"
fi

# Parse remaining components
minor=$((minor_patch / 100))
patch=$((minor_patch % 100))

# Perform version bump if requested
if $BUMP_MINOR || $BUMP_PATCH; then
    current_year="$(date +"%y")"
    if [[ "$major" < "$current_year" ]]; then
        # Year/major has changed -> reset all
        major="$current_year"
        minor=1
        patch=0
    elif $BUMP_MINOR; then
        # Bump minor, reset patch
        minor="$((minor + 1))"
        patch=0
    else
        # Bump patch
        patch="$((patch + 1))"
    fi
fi

if [ "$minor" -gt 99 ] || [ "$patch" -gt 99 ]; then
    echo "Cannot bump version number, because numerical limit is reached."
    exit 3
fi

# Output parsed version
if $INTEGER; then
    printf -v output "%02d%02d%02d%02d\n" "$prefix" "$major" "$minor" "$patch"
    trim_leading_zeros "$output"
else
    printf "%02d.%02d.%02d%02d\n" "$prefix" "$major" "$minor" "$patch"
fi

# Verbose output
if $VERBOSE; then
    echo ""
    printf "Project ID:\t%d\n" "$prefix"
    printf "Major:\t\t20%02d\n" "$major"
    printf "Minor:\t\t%d\n" "$minor"
    printf "Patch:\t\t%d\n" "$patch"
fi
