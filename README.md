# NonSemVer

## Overview

Not all systems can follow [Semantic Versioning](http://semver.org/), unfortunately.

Legacy constraints, organizational requirements or historical decision sometimes result in custom
version schemes not following common standards.

`NonSemVer.sh` is a single shell script designed to parse, normalize, inspect, and manipulate a
specific non-standard versioning scheme in a deterministic and user-friendly way.
This makes it ideal for use in CI pipelines or other automation workflows.

The version format is defined as follows:

    PP.CC.MMmm[-BBBB]
    |  |  | |   |
    |  |  | |   +--- Build sequence (optional)
    |  |  | +------- Bugfix component
    |  |  +--------- Minor component
    |  +------------ Cycle identifier
    +--------------- Version prefix

## Features and Examples

For a complete list of available options, run `NonSemVer.sh --help` or take a look at the unit
tests.

> All CLI options listed below can be combined unless stated otherwise.

### Parsing and Output

- Version tags can be parsed both from dot-style and integer notation:

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

- Bare integer versions can be printed with `-i` or `--integer`:

      $ ./NonSemVer.sh -i 00.00.0005
      5
      $ ./NonSemVer.sh -i 9.8.7-6
      90800070006

- Verbose and human-readable information can be shown with `-v` or `--verbose`:

      $ ./NonSemVer.sh -v 01.42.5069-3
      01.42.5069-0003

      Version prefix:       1
      Cycle identifier:     2042
      Minor component:      50
      Bugfix component:     69
      Build sequence:       3

### Version Manipulation

- Version numbers can be incremented with respect to the current cycle. If not specified, the
  current year's last 2 digits are taken as cycle number (e.g. for 2020):

      $ ./NonSemVer.sh --minor 00.20.1234
      00.20.1300
      $ ./NonSemVer.sh --bugfix 00.20.1234
      00.20.1235
      $ ./NonSemVer.sh --minor 00.19.1234
      00.20.0100
      $ ./NonSemVer.sh --bugfix 00.19.1234
      00.20.0100
      $ ./NonSemVer.sh --cycle 19 --minor 00.19.1234
      00.19.1300

- Derive a synthetic version format by shifting decimal places:

      $ ./NonSemVer.sh 11.22.3344
      11.22.3344
      $ ./NonSemVer.sh 11.22.3344 --synthetic 8899
      11.22.3388-4499
      $ ./NonSemVer.sh 11.22.3344 --synthetic 709 -i
      112233074409

  Note that with synthetic versions, the output will _always_ contain build sequence numbers.

### Native git Integration

- When running inside a git repository, the latest tag will be fetched as version argument:

      $ git tag -l
      1.2.30
      $ ./NonSemVer.sh
      01.02.0030
