#!/bin/bash

# Check output in verbose mode
assert_contain "$($NONSEMVER -v v1.2.304-56)"   "01.02.0304-0056"               "Version string in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Version prefix:\t\t1'         "Version prefix in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Cycle identifier:\t2002'      "Cycle identifier in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Minor component:\t3'          "Minor component in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Bugfix component:\t4'         "Bugfix component in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Build sequence:\t\t56'        "Build sequence in verbose output"
