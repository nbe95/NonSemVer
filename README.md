# NonSemVer

## Introduction

Sometimes legacy systems or technical constraints lead to versioning schemes not following
[Semantic Versioning](http://semver.org/).

This shell script is useful for handling a versioning scheme not following common standards.
With such unconventional principles, `NonSemVer.sh` can correctly display, parse, and even increment
version numbers as needed.

This makes it ideal for use in CI pipelines and other automation workflows.

## The scheme

    PP.CC.MMmm-BBBB
    |  |  | |  |
    |  |  | |  +---- Build sequence
    |  |  | +------- Minor component
    |  |  +--------- Major component
    |  +------------ Cycle identifier
    +--------------- Version prefix
