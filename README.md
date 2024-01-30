# NonSemVer

## The problem

Sometimes legacy systems or technical constraints lead to versioning schemes not following
[Semantic Versioning](http://semver.org/).

    PP.YY.MMmm-BBBB
    |  |  | |  |
    |  |  | |  +---- Build number
    |  |  | +------- Minor release
    |  |  +--------- Major release
    |  +------------ Year of deployment
    +--------------- Prefix/project identifier

## The solution

This shell script is useful for handling a versioning scheme not following common standards.
With such unconventional principles, `NonSemVer.sh` can correctly display, parse, and even increment
version numbers as needed.

This makes it ideal for use in CI pipelines and other automation workflows.

### Features and examples

- Parse version tags in dot-style or integer notation:

        $ ./NonSemVer.sh 12.34.5678
        12.34.5678
        $ ./NonSemVer.sh 12345
        00.01.2345

- Return bare integer version tags with `-i` or `--integer`:

        $ ./NonSemVer.sh -i 9.8.7
        9080007
        $ ./NonSemVer.sh -i 00.00.0005
        5

- Print verbose and human-readable information with `-v` or `--verbose`

        $ ./NonSemVer.sh -i -v 00.42.0069
        420069

        Project ID:         0
        Deployment year:    2042
        Major version:      42
        Minor version:      69

- When running in a Git repository, automatically fetch the latest tag as
  version identifier:

        $ git tag
        1.2.30
        $ ./NonSemVer.sh
        01.02.0030

- Increment version numbers (with respect to the current year, e.g. 2023):

        $ ./NonSemVer.sh --minor 11.23.0607
        11.23.0700
        $ ./NonSemVer.sh --major 11.23.0607
        11.23.0608
        $ ./NonSemVer.sh --minor 11.20.1234
        11.23.0100

Run `./NonSemVer.sh --help` or take a look at the unit tests to see all available
options.
