#!/bin/bash

# Prepare current, next and previous cycle as variables
cc="$(date +%y)"
nc=$((cc + 1))
pc=$((cc - 1))

# Check minor/bugfix version bump
assert_eq "$($NONSEMVER --minor     "00.00.0000"        )"  "00.$cc.0100"   "Minor bump with invalid cycle"
assert_eq "$($NONSEMVER --minor     "42.$pc.1234"       )"  "42.$cc.0100"   "Minor bump with earlier cycle"
assert_eq "$($NONSEMVER --minor     "01.$nc.2468"       )"  "01.$nc.2500"   "Minor bump with future cycle"
assert_eq "$($NONSEMVER --bugfix    "69.00.0000"        )"  "69.$cc.0100"   "Bugfix bump with invalid cycle"
assert_eq "$($NONSEMVER --bugfix    "99.$pc.9999"       )"  "99.$cc.0100"   "Bugfix bump with earlier cycle"
assert_eq "$($NONSEMVER --bugfix    "01.$nc.2468"       )"  "01.$nc.2469"   "Bugfix bump with future cycle"

assert_eq "$($NONSEMVER --minor     "00.$cc.0000"       )"  "00.$cc.0100"   "Regular minor bump 1"
assert_eq "$($NONSEMVER --minor     "12.$cc.3456"       )"  "12.$cc.3500"   "Regular minor bump 2"
assert_eq "$($NONSEMVER --minor     "78.$cc.9012"       )"  "78.$cc.9100"   "Regular minor bump 3"
assert_eq "$($NONSEMVER --minor     "78.$cc.9012"       )"  "78.$cc.9100"   "Regular minor bump 4"

assert_eq "$($NONSEMVER --bugfix    "00.$cc.0000"       )"  "00.$cc.0001"   "Regular bugfix bump 1"
assert_eq "$($NONSEMVER --bugfix    "12.$cc.3456"       )"  "12.$cc.3457"   "Regular bugfix bump 2"
assert_eq "$($NONSEMVER --bugfix    "78.$cc.9012"       )"  "78.$cc.9013"   "Regular bugfix bump 3"

# When having both, --minor takes precedence
assert_eq "$($NONSEMVER --minor --bugfix "00.$cc.1234"  )"  "00.$cc.1300"   "Minor takes precedence over bugfix"

# Check for explicitly specified base cycles
assert_eq "$($NONSEMVER --cycle 42 --minor  00.41.1234  )"  "00.42.0100"    "Minor bump with earlier base cycle"
assert_eq "$($NONSEMVER --cycle 42 --minor  00.42.1234  )"  "00.42.1300"    "Minor bump with same base cycle"
assert_eq "$($NONSEMVER --cycle 42 --minor  00.43.1234  )"  "00.43.1300"    "Minor bump with future base cycle"

assert_eq "$($NONSEMVER --cycle 69 --bugfix 00.68.1234  )"  "00.69.0100"    "Bugfix bump with earlier base cycle"
assert_eq "$($NONSEMVER --cycle 69 --bugfix 00.69.1234  )"  "00.69.1235"    "Bugfix bump with same base cycle"
assert_eq "$($NONSEMVER --cycle 69 --bugfix 00.69.1234  )"  "00.69.1235"    "Bugfix bump with future base cycle"

# Check exceeding of numerical limits
assert_eq "$($NONSEMVER --bugfix    "00.$cc.5597"       )"  "00.$cc.5600"   "Overflow after bugfix 97 bump"
assert_eq "$($NONSEMVER --minor --cycle 1   00.00.0000  )"  "00.01.0100"    "Bump with single-digit base cycle"
assert_eq "$($NONSEMVER --minor --cycle 123 00.00.0000  )"  "00.12.0100"    "Bump with too long base cycle"

assert_eq       "$(bash +e -c '$NONSEMVER --minor 12.34.9956            &>/dev/null; echo $?')" 3 "Out of available minor versions"
assert_not_eq   "$(bash +e -c '$NONSEMVER --minor --cycle "" 12.34.9956 &>/dev/null; echo $?')" 0 "Bump with empty base cycle"
assert_not_eq   "$(bash +e -c '$NONSEMVER --minor --cycle fo 12.34.9956 &>/dev/null; echo $?')" 0 "Bump with invalid base cycle"
