#!/bin/bash

# Abort on error
set -e

usage() {
    echo "Usage: $(basename "$0") [-h|--help] [-v|--verbose] [-i|--integer] [--bump-minor|--bump-bugfix] [--synthetic ID] [VERSION]" 1>&2;
    exit 0;
}

# Parse argument options
VERBOSE=false
INTEGER=false
BUMP_MINOR=false
BUMP_BUGFIX=false
SYNTHETIC=0
while true; do
  case "$1" in
    -h | --help ) usage;;
    -v | --verbose ) VERBOSE=true; shift;;
    -i | --integer ) INTEGER=true; shift;;
    --bump-minor ) BUMP_MINOR=true; shift;;
    --bump-bugfix ) BUMP_BUGFIX=true; shift;;
    --synthetic ) SYNTHETIC="$(printf "%04d" "${2:0:4}")"; shift; shift;;
    * ) break;;
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
if [[ "$version" =~ ^v?([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,4})-?([0-9]{1,4})?$ ]]; then
    prefix=$((10#${BASH_REMATCH[1]:-0}))
    cycle=$((10#${BASH_REMATCH[2]:-0}))
    minor_bugfix=$((10#${BASH_REMATCH[3]:-0}))
    build=${BASH_REMATCH[4]}

else
    # Match an integer else (pad with zeros and replace anything but numbers)
    if [[ ! "$version" =~ ^v?[0-9]{1,12}$ ]]; then
        echo "Version tag '$version' has invalid format."
        exit 2
    fi
    version="${version//[^0-9]/}"
    printf -v version "%08d" $((10#$version))

    prefix=$((10#${version:0:2}))
    cycle=$((10#${version:2:2}))
    minor_bugfix=$((10#${version:4:4}))
    if (( "${#version}" > 8 )); then
        build=$((10#${version:8:4}))
    else
        build=""
    fi
fi

# Parse remaining components
minor=$((minor_bugfix / 100))
bugfix=$((minor_bugfix % 100))

# Perform version bump if requested
if $BUMP_MINOR || $BUMP_BUGFIX; then
    current="$(date +"%y")"
    if (( "$cycle" < "$current" )); then
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

# Synthetic version -> Shift decimal places
if [ "$SYNTHETIC" -ne 0 ]; then
    build="$(printf "%02d" "$bugfix")$(printf "%02d" "$((10#$SYNTHETIC % 100))")"
    bugfix="$(printf "%02d" "${SYNTHETIC:0:2}")"
fi

# Output parsed version
printf -v output "%02d.%02d.%02d%02d" "$prefix" "$cycle" "$minor" "$bugfix"
if [ -n "$build" ]; then
    printf -v output "%s-%04d" "$output" "$((10#$build))"
fi
if $INTEGER; then
    output=$((10#${output//[^0-9]/}))
fi
echo "$output"

# Verbose output
if $VERBOSE; then
    echo ""
    printf "Version prefix:\t\t%02d\n" "$prefix"
    printf "Cycle identifier:\t20%02d\n" "$cycle"
    printf "Minor component:\t%02d\n" "$minor"
    printf "Bugfix component:\t%02d\n" "$bugfix"
    printf "Build sequence:\t\t%04d\n" "${build:-0}"
fi
