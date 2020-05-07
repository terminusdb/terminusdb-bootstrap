#!/bin/bash
shellcheck terminusdb-container
bats .ci/test/basic.bats -p
