# NonSemVer

## Overview

Not all systems can follow [Semantic Versioning](http://semver.org/), unfortunately.

Legacy constraints, organizational requirements or historical decision sometimes result in custom
version schemes not following common standards.

`NonSemVer.sh` is a single shell script designed to parse, normalize, inspect, and manipulate a
specific non-standard versioning scheme in a deterministic and user-friendly way.
This makes it ideal for use in CI pipelines or other automation workflows.

The version format is defined as follows:

    PP.YY.MMmm[-BBBB]
    |  |  | |   |
    |  |  | |   +--- Build number (optional)
    |  |  | +------- Bugfix version
    |  |  +--------- Minor version
    |  +------------ Year of deployment
    +--------------- Prefix/project identifier

## Features and Examples

> All CLI options listed below can be combined unless stated otherwise.

For a complete list of available options, run `NonSemVer.sh --help` or take a look at the unit
tests.

### Parsing and Output

- Version tags can be parsed both from dot-style and integer notation:

      $ ./NonSemVer.sh 12.34.5678         # dot-style
      12.34.5678
      $ ./NonSemVer.sh v98.76.5432        # dot style with leading 'v'
      98.76.5432
      $ ./NonSemVer.sh 24681012           # integer format
      24.68.1012
      $ ./NonSemVer.sh 1.2.3-4            # abbreviated dot-style with build number
      01.02.0003-0004
      $ ./NonSemVer.sh v112233445566      # integer format with build number and 'v'
      11.22.3344-5566

  Note that a version's build number is optional and will be only printed if specified.

- Bare integer versions can be printed with `-i` or `--integer`:

      $ ./NonSemVer.sh -i 00.00.0005
      5
      $ ./NonSemVer.sh -i 9.8.7-6
      90800070006

- Verbose and human-readable information can be shown with `-v` or `--verbose`:

      $ ./NonSemVer.sh -v 01.42.5069-3
      01.42.5069-0003

      Project ID:     1
      Deployment:     2042
      Minor:          50
      Bugfix:         69
      Build:          3

### Version Manipulation

- Version numbers can be incremented with respect to the current year (e.g. 2023):

      $ ./NonSemVer.sh --bump-minor 11.23.0607
      11.23.0700
      $ ./NonSemVer.sh --bump-bugfix 11.23.0607
      11.23.0608
      $ ./NonSemVer.sh --bump-minor 11.20.1234
      11.23.0100

- Specific versions for testing can be created upon request:

      $ ./NonSemVer.sh 11.22.3344
      11.22.3344
      $ ./NonSemVer.sh 11.22.3344 --test 8899
      11.22.3388-4499
      $ ./NonSemVer.sh 11.22.3344 --test 709 -i
      112233074409

  Note that this will always output a build number.

### Native git Integration

- When running inside a Git repository, the latest tag will be fetched as version argument:

      $ git tag -l
      1.2.30
      $ ./NonSemVer.sh
      01.02.0030
