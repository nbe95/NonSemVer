#!/bin/bash

# Check proper creation of test versions
assert_eq "$($NONSEMVER --test "1234"   "00.00.0000")"  "00.00.0012-0034"   "Trivial test version"
assert_eq "$($NONSEMVER --test "4455"   "00.11.2233")"  "00.11.2244-3355"   "Basic test version"
assert_eq "$($NONSEMVER --test "789"    "00.01.2233")"  "00.01.2207-3389"   "Short test version"
assert_eq "$($NONSEMVER --test "1"      "77.77.8888")"  "77.77.8800-8801"   "Very short test version"
assert_eq "$($NONSEMVER --test "123456" "00.00.0000")"  "00.00.0012-0034"   "Long test version"

# Check handling of misformed arguments
$NONSEMVER --test ""   "00.00.0000" &>/dev/null;    assert_not_eq "$?" "0"  "No test version argument"

$NONSEMVER --test "1a" "00.00.0000" &>/dev/null;    assert_not_eq "$?" "0"  "Invalid test version argument"
