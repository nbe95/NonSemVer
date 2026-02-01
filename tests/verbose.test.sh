#!/bin/bash

# Check output in verbose mode
assert_contain "$($NONSEMVER -v v1.2.304-56)"   "01.02.0304-0056"               "Version string in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Version prefix:\t01'          "Version prefix in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Cycle identifier:\t\t2002'    "Major in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Minor component:\t\t03'       "Minor in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Bugfix component:\t\t04'      "Bugfix in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Build sequence:\t\t0056'      "Build in verbose output"
