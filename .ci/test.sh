#!/bin/bash
shellcheck terminusdb-container
shellcheck .ci/test/basic.bats
bats .ci/test/basic.bats -p
