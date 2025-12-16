#!/bin/bash


# Prepare current, next and previous year as variables
cy="$(date +"%y")"
ny=$((cy + 1))
py=$((cy - 1))


# Check minor/bugfix version bump
assert_eq "$($NONSEMVER --bump-minor "00.00.0000"  )" "00.$cy.0100" "Minor bump with invalid year"
assert_eq "$($NONSEMVER --bump-minor "42.$py.1234" )" "42.$cy.0100" "Minor bump with earlier year"
assert_eq "$($NONSEMVER --bump-minor "01.$ny.2468" )" "01.$ny.2500" "Minor bump with future year"
assert_eq "$($NONSEMVER --bump-bugfix "69.00.0000"  )" "69.$cy.0100" "Bugfix bump with invalid year"
assert_eq "$($NONSEMVER --bump-bugfix "99.$py.9999" )" "99.$cy.0100" "Bugfix bump with earlier year"
assert_eq "$($NONSEMVER --bump-bugfix "01.$ny.2468" )" "01.$ny.2469" "Bugfix bump with future year"

assert_eq "$($NONSEMVER --bump-minor "00.$cy.0000" )" "00.$cy.0100" "Regular minor bump"
assert_eq "$($NONSEMVER --bump-minor "12.$cy.3456" )" "12.$cy.3500" "Regular minor bump"
assert_eq "$($NONSEMVER --bump-minor "78.$cy.9012" )" "78.$cy.9100" "Regular minor bump"
assert_eq "$($NONSEMVER --bump-minor "78.$cy.9012" )" "78.$cy.9100" "Regular minor bump"

assert_eq "$($NONSEMVER --bump-bugfix "00.$cy.0000" )" "00.$cy.0001" "Regular bugfix bump"
assert_eq "$($NONSEMVER --bump-bugfix "12.$cy.3456" )" "12.$cy.3457" "Regular bugfix bump"
assert_eq "$($NONSEMVER --bump-bugfix "78.$cy.9012" )" "78.$cy.9013" "Regular bugfix bump"

# Check exceeding of numerical limits
assert_eq "$($NONSEMVER --bump-bugfix "00.$cy.5599" )" "00.$cy.5600" "Overflow after bugfix bump"
assert_eq "$($NONSEMVER --bump-minor 12.34.9956 &> /dev/null)$?" "3" "No more minor versions available"
