#!/bin/bash

remove_leading_zeros() {
  echo "$1" | sed 's/^0\+\(.\)/\1/'
}

# Pad input variable with leading zeros and replace anything but numbers
input="$(remove_leading_zeros "$(echo "$1" | sed 's/[^0-9]//g')")"
printf -v version "%08d" "$input"

# Match individual version components
regex="^([0-9]{2})([0-9]{2})([0-9]{4})$"
if [[ ! $version =~ $regex ]]; then
  echo "Version $version has invalid format."
  exit 1
fi

# Parse version components
customer="$(remove_leading_zeros "${BASH_REMATCH[1]}")"
year="$(remove_leading_zeros "${BASH_REMATCH[2]}")"
majmin="$(remove_leading_zeros "${BASH_REMATCH[3]}")"
major=$(($majmin / 100))
minor=$(($majmin % 100))

# Output parsed version
printf "%02d.%02d.%02d%02d\n" "$customer" "$year" "$major" "$minor"

# Verbose output
echo ""
printf "Customer ID:\t\t%d\n" "$customer"
printf "Deployment year:\t20%02d\n" "$year"
printf "Major version:\t\t%d\n" "$major"
printf "Minor version:\t\t%d\n" "$minor"
