#!/bin/bash

# Check output in verbose mode
assert_contain "$($NONSEMVER -v v1.2.304-56)"   "01.02.0304-0056"               "Should print version string in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Version prefix:\t\t1'         "Should print version prefix in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Cycle identifier:\t2002'      "Should print cycle identifier in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Minor component:\t3'          "Should print minor component in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Bugfix component:\t4'         "Should print bugfix component in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Build sequence:\t\t56'        "Should print build sequence in verbose output"
