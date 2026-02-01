#!/bin/bash

# Check argument format (exit codes only)
$NONSEMVER -h               &>/dev/null;    assert_eq "$?" "0" "Exit code 0 for help"
$NONSEMVER --help           &>/dev/null;    assert_eq "$?" "0" "Exit code 0 for help"

$NONSEMVER                  &>/dev/null;    assert_eq "$?" "1" "Exit code 1 without arguments"

$NONSEMVER foo              &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER foo123           &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER foo.bar.123      &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER 1.2              &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER 12...33          &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER 12.34.56.78      &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER 12.345.678       &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER 1234.56.78       &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER 1234567812345    &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
$NONSEMVER 12.34.5678-12345 &>/dev/null;    assert_eq "$?" "2" "Exit code 2 for invalid argument"
