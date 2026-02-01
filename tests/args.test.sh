#!/bin/bash

# Check argument format (exit codes only)
assert_eq "$($NONSEMVER -h            &> /dev/null)$?" "0" "Exit code 0 for -h"
assert_eq "$($NONSEMVER --help        &> /dev/null)$?" "0" "Exit code 0 for --help"

assert_eq "$($NONSEMVER               &> /dev/null)$?" "1" "Exit code 1 without arguments"

assert_eq "$($NONSEMVER foo           &> /dev/null)$?" "2" "Exit code 2 for invalid argument 1"
assert_eq "$($NONSEMVER foo123        &> /dev/null)$?" "2" "Exit code 2 for invalid argument 2"
assert_eq "$($NONSEMVER foo.bar.123   &> /dev/null)$?" "2" "Exit code 2 for invalid argument 3"
assert_eq "$($NONSEMVER 1.2           &> /dev/null)$?" "2" "Exit code 2 for invalid argument 4"
assert_eq "$($NONSEMVER 12...33       &> /dev/null)$?" "2" "Exit code 2 for invalid argument 5"
assert_eq "$($NONSEMVER 12.34.56.78   &> /dev/null)$?" "2" "Exit code 2 for invalid argument 6"
assert_eq "$($NONSEMVER 12.345.678    &> /dev/null)$?" "2" "Exit code 2 for invalid argument 7"
assert_eq "$($NONSEMVER 1234.56.78    &> /dev/null)$?" "2" "Exit code 2 for invalid argument 8"
