#!/bin/bash

# Check invalid argument format (exit codes only)
assert_eq "$($NONSEMVER               &> /dev/null)$?" "1" "Argument check"
assert_eq "$($NONSEMVER foo           &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER foo123        &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER foo.bar.123   &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER 1.2           &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER 12...33       &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER 12.34.56.78   &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER 12.345.678    &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER 1234.56.78    &> /dev/null)$?" "2" "Argument check"
assert_eq "$($NONSEMVER 123456789     &> /dev/null)$?" "2" "Argument check"
