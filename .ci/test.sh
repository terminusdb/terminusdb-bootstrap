#!/bin/bash
shellcheck terminus-container
./terminus-container help
./terminus-container run
nohup ./terminus-container console
nohup ./terminus-container attach
./terminus-container stop
yes | ./terminus-container rm
./terminus-container test
