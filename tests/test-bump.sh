#!/bin/bash


# Prepare current, next and previous cycle as variables
cy="$(date +"%y")"
ny=$((cy + 1))
py=$((cy - 1))


# Check exceeding of version limits
assert_eq "$($NONSEMVER --bump-minor 12.34.9956    &> /dev/null)$?" "3" "Version limit"
assert_eq "$($NONSEMVER --bump-patch 12.34.5699    &> /dev/null)$?" "3" "Version limit"


# Check minor/patch version bump
assert_eq "$($NONSEMVER --bump-minor "00.00.0000"  )" "00.$cy.0100" "Version bump"
assert_eq "$($NONSEMVER --bump-minor "42.$py.1234" )" "42.$cy.0100" "Version bump"
assert_eq "$($NONSEMVER --bump-minor "01.$ny.2468" )" "01.$ny.2500" "Version bump"
assert_eq "$($NONSEMVER --bump-patch "69.00.0000"  )" "69.$cy.0100" "Version bump"
assert_eq "$($NONSEMVER --bump-patch "99.$py.9999" )" "99.$cy.0100" "Version bump"
assert_eq "$($NONSEMVER --bump-patch "01.$ny.2468" )" "01.$ny.2469" "Version bump"

assert_eq "$($NONSEMVER --bump-minor "00.$cy.0000" )" "00.$cy.0100" "Version bump"
assert_eq "$($NONSEMVER --bump-minor "12.$cy.3456" )" "12.$cy.3500" "Version bump"
assert_eq "$($NONSEMVER --bump-minor "78.$cy.9012" )" "78.$cy.9100" "Version bump"
assert_eq "$($NONSEMVER --bump-minor "78.$cy.9012" )" "78.$cy.9100" "Version bump"

assert_eq "$($NONSEMVER --bump-patch "00.$cy.0000" )" "00.$cy.0001" "Version bump"
assert_eq "$($NONSEMVER --bump-patch "12.$cy.3456" )" "12.$cy.3457" "Version bump"
assert_eq "$($NONSEMVER --bump-patch "78.$cy.9012" )" "78.$cy.9013" "Version bump"
