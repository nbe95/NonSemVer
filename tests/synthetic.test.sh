#!/bin/bash

# Check proper creation of synthetic versions
assert_eq "$($NONSEMVER --synthetic "1234"      "00.00.0000")"  "00.00.0012-0034"   "Trivial synthetic version"
assert_eq "$($NONSEMVER --synthetic "4455"      "00.11.2233")"  "00.11.2244-3355"   "Basic synthetic version"
assert_eq "$($NONSEMVER --synthetic "789"       "00.01.2233")"  "00.01.2207-3389"   "Short synthetic version"
assert_eq "$($NONSEMVER --synthetic "1"         "77.77.8888")"  "77.77.8800-8801"   "Very short synthetic version"
assert_eq "$($NONSEMVER --synthetic "123456"    "00.00.0000")"  "00.00.0012-0034"   "Long synthetic version"

# Check handling of misformed arguments
assert_not_eq "$($NONSEMVER --synthetic ""      "00.00.0000" &>/dev/null)$?" "0"    "No synthetic version argument"
assert_not_eq "$($NONSEMVER --synthetic "1a"    "00.00.0000" &>/dev/null)$?" "0"    "Invalid synthetic version argument"
