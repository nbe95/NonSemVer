#!/bin/bash

# Check argument format (exit codes only)
assert_eq "$($CMD -h            &> /dev/null)$?" "0" "Exit code 0 for help"
assert_eq "$($CMD --help        &> /dev/null)$?" "0" "Exit code 0 for help"

assert_eq "$($CMD               &> /dev/null)$?" "1" "Exit code 1 without arguments"

assert_eq "$($CMD foo           &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD foo123        &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD foo.bar.123   &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD 1.2           &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD 12...33       &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD 12.34.56.78   &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD 12.345.678    &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD 1234.56.78    &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
assert_eq "$($CMD 123456789     &> /dev/null)$?" "2" "Exit code 2 for invalid argument"
