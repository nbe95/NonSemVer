#!/bin/bash

# Abort on error
set -e

# shellcheck disable=SC2001
trim_leading_zeros() { echo -n "$1" | sed 's/^0\+\(.\)/\1/'; }
usage() { echo "Usage: $(basename "$0") [-h|--help] [-v|--verbose] [-i|--integer] [--bump-minor|--bump-bugfix] [VERSION]" 1>&2; exit 0; }

# Parse argument options
VERBOSE=false
INTEGER=false
BUMP_MINOR=false
BUMP_BUGFIX=false
while true; do
  case "$1" in
    -h | --help ) usage ;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -i | --integer ) INTEGER=true; shift ;;
    --bump-minor ) BUMP_MINOR=true; shift ;;
    --bump-bugfix ) BUMP_BUGFIX=true; shift ;;
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
    cycle="$(trim_leading_zeros "${BASH_REMATCH[2]}")"
    minor_bugfix="$(trim_leading_zeros "${BASH_REMATCH[3]}")"

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
    cycle="$(trim_leading_zeros "${version:2:2}")"
    minor_bugfix="$(trim_leading_zeros "${version:4:4}")"
fi

# Parse remaining components
minor=$((minor_bugfix / 100))
bugfix=$((minor_bugfix % 100))

# Perform version bump if requested
if $BUMP_MINOR || $BUMP_BUGFIX; then
    current="$(date +"%y")"
    if [[ "$cycle" < "$current" ]]; then
        # Cycle ID has changed -> reset all
        cycle="$current"
        minor=1
        bugfix=0
    elif $BUMP_MINOR; then
        # Bump minor, reset bugfix
        minor="$((minor + 1))"
        bugfix=0
    else
        # Bump bugfix
        bugfix="$((bugfix + 1))"
    fi

    # Bump minor version if bugfix version > 97, since 98/99 are reserved for special cases
    if [ "$bugfix" -gt 97 ]; then
        minor="$((minor + 1))"
        bugfix=0
    fi
fi

if [ "$minor" -gt 99 ]; then
    echo "Cannot bump minor number, because numerical limit is reached."
    exit 3
fi

# Output parsed version
if $INTEGER; then
    printf -v output "%02d%02d%02d%02d\n" "$prefix" "$cycle" "$minor" "$bugfix"
    trim_leading_zeros "$output"
else
    printf "%02d.%02d.%02d%02d\n" "$prefix" "$cycle" "$minor" "$bugfix"
fi

# Verbose output
if $VERBOSE; then
    echo ""
    printf "Version prefix:\t\t%d\n" "$prefix"
    printf "Cycle identifier:\t20%02d\n" "$cycle"
    printf "Minor component:\t%d\n" "$minor"
    printf "Patch component:\t%d\n" "$patch"
fi
