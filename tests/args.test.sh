#!/bin/bash

# Check exit codes for invalid arguments
# (single quotes and +e are required not to die on intended errors)
assert_eq "$(bash +e -c '$NONSEMVER -h               &>/dev/null; echo $?')" 0 "Should exit with code 0 when called with -h"
assert_eq "$(bash +e -c '$NONSEMVER --help           &>/dev/null; echo $?')" 0 "Should exit with code 0 when called with --help"

assert_eq "$(bash +e -c '$NONSEMVER                  &>/dev/null; echo $?')" 1 "Should exit with code 1 without arguments"

assert_eq "$(bash +e -c '$NONSEMVER foo              &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER foo123           &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER foo.bar.123      &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER 1.2              &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER 12...33          &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER 12.34.56.78      &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER 12.345.678       &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER 1234.56.78       &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER 1234567812345    &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
assert_eq "$(bash +e -c '$NONSEMVER 12.34.5678-12345 &>/dev/null; echo $?')" 2 "Should exit with code 2 on invalid argument"
