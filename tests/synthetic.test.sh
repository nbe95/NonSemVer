#!/bin/bash

# Check proper creation of synthetic versions
assert_eq "$($NONSEMVER --synthetic ''      00.00.0000)"    "00.00.0000"        "Should ignore empty synthetic version"

# Check handling of misformed arguments

assert_not_eq "$(bash +e -c '$NONSEMVER --synthetic 1a      00.00.0000 &>/dev/null; echo $?')" 0 "Invalid synthetic version argument"
