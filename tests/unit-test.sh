#!/bin/bash

DIR="$(dirname "$0")"
NONSEMVER="$DIR/../NonSemVer.sh"

# shellcheck disable=SC1091
source "$DIR/assert/assert.sh"


# Invalid argument format (check exit codes only)
assert_eq "$($NONSEMVER               &> /dev/null)$?" "1" "invalid"
assert_eq "$($NONSEMVER foo           &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER foo123        &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER foo.bar.123   &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER 1.2           &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER 12...33       &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER 12.34.56.78   &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER 12.345.678    &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER 1234.56.78    &> /dev/null)$?" "2" "invalid"
assert_eq "$($NONSEMVER 123456789     &> /dev/null)$?" "2" "invalid"


# Basic dot notation
assert_eq "$($NONSEMVER 0             )" "00.00.0000" "invalid"
assert_eq "$($NONSEMVER 1             )" "00.00.0001" "invalid"
assert_eq "$($NONSEMVER 00.00.1234    )" "00.00.1234" "invalid"
assert_eq "$($NONSEMVER 0.6.9         )" "00.06.0009" "invalid"
assert_eq "$($NONSEMVER 00.42.00      )" "00.42.0000" "invalid"
assert_eq "$($NONSEMVER 99.00.0       )" "99.00.0000" "invalid"
assert_eq "$($NONSEMVER 12.34.5678    )" "12.34.5678" "invalid"
assert_eq "$($NONSEMVER 99.99.9999    )" "99.99.9999" "invalid"


# Basic integer notation
assert_eq "$($NONSEMVER 0             )" "00.00.0000" "invalid"
assert_eq "$($NONSEMVER 1             )" "00.00.0001" "invalid"
assert_eq "$($NONSEMVER 420000        )" "00.42.0000" "invalid"
assert_eq "$($NONSEMVER 69000000      )" "69.00.0000" "invalid"
assert_eq "$($NONSEMVER 12345678      )" "12.34.5678" "invalid"
assert_eq "$($NONSEMVER 99999999      )" "99.99.9999" "invalid"

assert_eq "$($NONSEMVER -i 0          )" "00000000" "invalid"
assert_eq "$($NONSEMVER -i 1          )" "00000001" "invalid"
assert_eq "$($NONSEMVER -i 00.00.1234 )" "00001234" "invalid"
assert_eq "$($NONSEMVER -i 00.42.0000 )" "00420000" "invalid"
assert_eq "$($NONSEMVER -i 69.00.0000 )" "69000000" "invalid"
assert_eq "$($NONSEMVER -i 12.34.5678 )" "12345678" "invalid"
assert_eq "$($NONSEMVER -i 99.99.9999 )" "99999999" "invalid"


# Prepare current, next and previous year as variables
CY="$(date +"%y")"
NY=$((CY + 1))
PY=$((CY - 1))

# Version bump
assert_eq "$($NONSEMVER --major 12.34.9956    &> /dev/null)$?" "3" "invalid"
assert_eq "$($NONSEMVER --minor 12.34.5699    &> /dev/null)$?" "3" "invalid"

assert_eq "$($NONSEMVER --major "00.00.0000"  )" "00.$CY.0100" "invalid"
assert_eq "$($NONSEMVER --major "42.$PY.1234" )" "42.$CY.0100" "invalid"
assert_eq "$($NONSEMVER --major "01.$NY.2468" )" "01.$NY.2500" "invalid"
assert_eq "$($NONSEMVER --minor "69.00.0000"  )" "69.$CY.0100" "invalid"
assert_eq "$($NONSEMVER --minor "99.$PY.9999" )" "99.$CY.0100" "invalid"
assert_eq "$($NONSEMVER --minor "01.$NY.2468" )" "01.$NY.2469" "invalid"

assert_eq "$($NONSEMVER --major "00.$CY.0000" )" "00.$CY.0100" "invalid"
assert_eq "$($NONSEMVER --major "12.$CY.3456" )" "12.$CY.3500" "invalid"
assert_eq "$($NONSEMVER --major "78.$CY.9012" )" "78.$CY.9100" "invalid"
assert_eq "$($NONSEMVER --major "78.$CY.9012" )" "78.$CY.9100" "invalid"

assert_eq "$($NONSEMVER --minor "00.$CY.0000" )" "00.$CY.0001" "invalid"
assert_eq "$($NONSEMVER --minor "12.$CY.3456" )" "12.$CY.3457" "invalid"
assert_eq "$($NONSEMVER --minor "78.$CY.9012" )" "78.$CY.9013" "invalid"
