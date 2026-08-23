#!/bin/bash

# Check proper creation of synthetic versions
assert_eq "$($NONSEMVER --synthetic ''      00.00.0000)"    "00.00.0000"        "Should ignore empty synthetic version"
assert_eq "$($NONSEMVER --synthetic 1234    00.00.0000)"    "00.00.0012-0034"   "Should handle trivial synthetic version"
assert_eq "$($NONSEMVER --synthetic 4455    00.11.2233)"    "00.11.2244-3355"   "Should handle basic synthetic version"
assert_eq "$($NONSEMVER --synthetic 789     00.01.2233)"    "00.01.2207-3389"   "Should handle short synthetic version"
assert_eq "$($NONSEMVER --synthetic 1       77.77.8888)"    "77.77.8800-8801"   "Should handle very short synthetic version"
assert_eq "$($NONSEMVER --synthetic 123456  00.00.0000)"    "00.00.0012-0034"   "Should handle long synthetic version"

# Check handling of misformed arguments
assert_not_eq "$(bash +e -c '$NONSEMVER --synthetic 1foo 00.00.0000 &>/dev/null; echo $?')" 0 "Should throw in invalid synthetic argument"
