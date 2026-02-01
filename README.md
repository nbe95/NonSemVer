# NonSemVer

## The Problem

Sometimes legacy systems or technical constraints lead to versioning schemes not following
[Semantic Versioning](http://semver.org/).

    PP.CC.MMmm[-BBBB]
    |  |  | |   |
    |  |  | |   +--- Build sequence
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

      $ ./NonSemVer.sh 12.34.5678         # dot-style
      12.34.5678
      $ ./NonSemVer.sh v98.76.5432        # dot style with leading 'v'
      98.76.5432
      $ ./NonSemVer.sh 24681012           # integer format
      24.68.1012
      $ ./NonSemVer.sh 1.2.3-4            # abbreviated dot-style with build sequence number
      01.02.0003-0004
      $ ./NonSemVer.sh v112233445566      # integer format with build sequence and 'v'
      11.22.3344-5566

  Note that a version's build sequence is optional and will be only printed if specified.

- Return bare integer version tags with `-i` or `--integer`:

        $ ./NonSemVer.sh -i 9.8.7-6
        90800070006
        $ ./NonSemVer.sh -i 00.00.0005
        5

- Print verbose and human-readable information with `-v` or `--verbose`

        $ ./NonSemVer.sh -i -v 01.42.5069-3
        14250690003

        Version prefix:     01
        Cycle identifier:   2042
        Minor component:    50
        Bugfix component:   69
        Build sequence:     0003

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

- Derive a synthetic version format by shifting decimal places:

        $ ./NonSemVer.sh 11.22.3344 --synthetic 5566
        11.22.3355-4466
        $ ./NonSemVer.sh 11.22.3344 -i --synthetic 789
        112233074489

  Note that this will always output the build sequence number.

Run `./NonSemVer.sh --help` or take a look at the unit tests to see all available options.
