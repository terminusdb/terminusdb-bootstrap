#!/bin/bash
shellcheck terminusdb-container
./terminusdb-container help
./terminusdb-container run
nohup ./terminusdb-container console
nohup ./terminusdb-container attach
./terminusdb-container stop
yes | ./terminusdb-container rm
./terminusdb-container test
