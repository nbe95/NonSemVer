#!/bin/bash

# Check dot-style parsing and output
assert_eq "$($CMD 0             )" "00.00.0000" "Dot notation parsing"
assert_eq "$($CMD 1             )" "00.00.0001" "Dot notation parsing"
assert_eq "$($CMD 00.00.1234    )" "00.00.1234" "Dot notation parsing"
assert_eq "$($CMD 0.6.9         )" "00.06.0009" "Dot notation parsing"
assert_eq "$($CMD 00.42.00      )" "00.42.0000" "Dot notation parsing"
assert_eq "$($CMD 99.00.0       )" "99.00.0000" "Dot notation parsing"
assert_eq "$($CMD 12.34.5678    )" "12.34.5678" "Dot notation parsing"
assert_eq "$($CMD 99.99.9999    )" "99.99.9999" "Dot notation parsing"

assert_eq "$($CMD v0            )" "00.00.0000" "Dot notation parsing"
assert_eq "$($CMD v1            )" "00.00.0001" "Dot notation parsing"
assert_eq "$($CMD v00.00.1234   )" "00.00.1234" "Dot notation parsing"
assert_eq "$($CMD v0.6.9        )" "00.06.0009" "Dot notation parsing"
assert_eq "$($CMD v00.42.00     )" "00.42.0000" "Dot notation parsing"
assert_eq "$($CMD v99.00.0      )" "99.00.0000" "Dot notation parsing"
assert_eq "$($CMD v12.34.5678   )" "12.34.5678" "Dot notation parsing"
assert_eq "$($CMD v99.99.9999   )" "99.99.9999" "Dot notation parsing"



# Check integer parsing and output
assert_eq "$($CMD 0             )" "00.00.0000" "Integer parsing"
assert_eq "$($CMD 1             )" "00.00.0001" "Integer parsing"
assert_eq "$($CMD 420000        )" "00.42.0000" "Integer parsing"
assert_eq "$($CMD 69000000      )" "69.00.0000" "Integer parsing"
assert_eq "$($CMD 12345678      )" "12.34.5678" "Integer parsing"
assert_eq "$($CMD 99999999      )" "99.99.9999" "Integer parsing"

assert_eq "$($CMD v0            )" "00.00.0000" "Integer parsing"
assert_eq "$($CMD v1            )" "00.00.0001" "Integer parsing"
assert_eq "$($CMD v420000       )" "00.42.0000" "Integer parsing"
assert_eq "$($CMD v69000000     )" "69.00.0000" "Integer parsing"
assert_eq "$($CMD v12345678     )" "12.34.5678" "Integer parsing"
assert_eq "$($CMD v99999999     )" "99.99.9999" "Integer parsing"

assert_eq "$($CMD -i 0          )"        "0" "Integer output"
assert_eq "$($CMD -i 1          )"        "1" "Integer output"
assert_eq "$($CMD -i 00.00.1234 )"     "1234" "Integer output"
assert_eq "$($CMD -i 00.42.0000 )"   "420000" "Integer output"
assert_eq "$($CMD -i 69.00.0000 )" "69000000" "Integer output"
assert_eq "$($CMD -i 12.34.5678 )" "12345678" "Integer output"
assert_eq "$($CMD -i 99.99.9999 )" "99999999" "Integer output"
