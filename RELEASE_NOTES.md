# TerminusDB Quickstart Version 2.0.1 Release Notes

## New

- Updated version of TerminusDB console.

See release notes in [TerminusDB Console](https://github.com/terminusdb/terminusdb-console) for details.

- Added exec feature to run commands inside container.
- Add build and end-to-end tests for TerminusdB console.
- Add improved importing of environment variables in tests.
- run TerminusDB server tests from bats tests.
- run cypress tests in bats

# TerminusDB Quickstart Version 2.0 Release Notes

## New

# TerminusDB Quickstart 2.0 is updated for use with TerminusDB Server 2.0, see release notes in [TerminusDB Server](https://github.com/terminusdb/terminusdb-server) for details.

## Backwards-Incompatible Changes

There has been a lot of clean up of environment variables, so if you have an old `ENV` file or are setting the variables by some other means, see [ENV.example](ENV.example) to find the correct names
