# NonSemVer

## The Problem

Sometimes legacy systems or technical constraints lead to versioning schemes not following
[Semantic Versioning](http://semver.org/).

    PP.CC.MMmm-BBBB
    |  |  | |  |
    |  |  | |  +---- Build sequence
    |  |  | +------- Patch component
    |  |  +--------- Minor component
    |  +------------ Cycle identifier
    +--------------- Version prefix

## The Solution

This shell script is useful for handling a versioning scheme not following common standards.
With such unconventional principles, `NonSemVer.sh` can correctly display, parse, and even increment
version numbers as needed.

This makes it ideal for use in CI pipelines and other automation workflows.

### Features and Examples

- Parse version tags in dot-style or integer notation:

        $ ./NonSemVer.sh v12.34.5678
        12.34.5678
        $ ./NonSemVer.sh 98.76.5432
        98.76.5432
        $ ./NonSemVer.sh 24681012
        24.68.1012

- Return bare integer version tags with `-i` or `--integer`:

        $ ./NonSemVer.sh -i 9.8.7
        9080007
        $ ./NonSemVer.sh -i 00.00.0005
        5

- Print verbose and human-readable information with `-v` or `--verbose`

        $ ./NonSemVer.sh -i -v 01.42.5069
        1425069

        Version prefix:     1
        Cycle identifier:   2042
        Minor component:    50
        Bugfix component:   69

- When running in a Git repository, automatically fetch the latest tag as version identifier:

        $ git tag
        1.2.30
        $ ./NonSemVer.sh
        01.02.0030

- Increment version numbers (with respect to the current year, e.g. 2023):

        $ ./NonSemVer.sh --bump-minor 11.23.0607
        11.23.0700
        $ ./NonSemVer.sh --bump-bugfix 11.23.0607
        11.23.0608
        $ ./NonSemVer.sh --bump-minor 11.20.1234
        11.23.0100

Run `./NonSemVer.sh --help` or take a look at the unit tests to see all available options.
