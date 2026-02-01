#!/bin/bash

# Check output in verbose mode
assert_contain "$($NONSEMVER -v v1.2.304-56)"   "01.02.0304-0056"   "Version string in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Project ID:\t1'   "Project ID in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Major:\t\t2002'   "Major in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Minor:\t\t3'      "Minor in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Bugfix:\t\t4'     "Bugfix in verbose output"
assert_contain "$($NONSEMVER -v v1.2.304-56)"   $'Build:\t\t56'     "Build in verbose output"
