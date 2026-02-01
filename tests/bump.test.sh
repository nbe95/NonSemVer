#!/bin/bash

# Prepare current, next and previous cycle as variables
cc="$(date +"%y")"
nc=$((cc + 1))
pc=$((cc - 1))

# Check minor/bugfix version bump
assert_eq "$($NONSEMVER --bump-minor    "00.00.0000"    )" "00.$cc.0100"    "Minor bump with invalid cycle"
assert_eq "$($NONSEMVER --bump-minor    "42.$pc.1234"   )" "42.$cc.0100"    "Minor bump with earlier cycle"
assert_eq "$($NONSEMVER --bump-minor    "01.$nc.2468"   )" "01.$nc.2500"    "Minor bump with future cycle"
assert_eq "$($NONSEMVER --bump-bugfix   "69.00.0000"    )" "69.$cc.0100"    "Bugfix bump with invalid cycle"
assert_eq "$($NONSEMVER --bump-bugfix   "99.$pc.9999"   )" "99.$cc.0100"    "Bugfix bump with earlier cycle"
assert_eq "$($NONSEMVER --bump-bugfix   "01.$nc.2468"   )" "01.$nc.2469"    "Bugfix bump with future cycle"

assert_eq "$($NONSEMVER --bump-minor    "00.$cc.0000"   )" "00.$cc.0100"    "Regular minor bump"
assert_eq "$($NONSEMVER --bump-minor    "12.$cc.3456"   )" "12.$cc.3500"    "Regular minor bump"
assert_eq "$($NONSEMVER --bump-minor    "78.$cc.9012"   )" "78.$cc.9100"    "Regular minor bump"
assert_eq "$($NONSEMVER --bump-minor    "78.$cc.9012"   )" "78.$cc.9100"    "Regular minor bump"

assert_eq "$($NONSEMVER --bump-bugfix   "00.$cc.0000"   )" "00.$cc.0001"    "Regular bugfix bump"
assert_eq "$($NONSEMVER --bump-bugfix   "12.$cc.3456"   )" "12.$cc.3457"    "Regular bugfix bump"
assert_eq "$($NONSEMVER --bump-bugfix   "78.$cc.9012"   )" "78.$cc.9013"    "Regular bugfix bump"

# Check exceeding of numerical limits
assert_eq "$($NONSEMVER --bump-bugfix   "00.$cc.5599"   )" "00.$cc.5600"    "Overflow after bugfix bump"
assert_eq "$($NONSEMVER --bump-minor    "12.34.9956" &>/dev/null)$?" "3"    "No more minor versions available"
