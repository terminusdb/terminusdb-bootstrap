```
████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗███████╗
╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔════╝
   ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║███████╗
   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║╚════██║
   ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝███████║
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
                                                                  
```

# TerminusDB Server Container Control

This is a simple convenience script to run terminus-server as a docker container. These instructions are for linux or similar

What the heck is TerminusDB? See here: https://terminusdb.com

## Prerequisites

- docker

Obvs, you need to have docker running.

- sudo

Since letting unprivileged users run docker is like insecure and all, this script uses sudo, so get your sudoers on.

## Get this script, cd to it

```
$ git clone https://github.com/dmytri/terminus-container
$ cd terminus-container
```

## Run the container

```
$ ./terminus-container run

Unable to find image 'terminusdb/terminus-server:latest' locally
latest: Pulling from terminusdb/terminus-server
8f91359f1fff: Pulling fs layer
939634dec138: Pulling fs layer
f30474226dd6: Pulling fs layer
32a63113e3ae: Pulling fs layer
ae35de9092ce: Pulling fs layer
023c02983955: Pulling fs layer
d9fa4a1acf93: Pulling fs layer
[ ... ]
```

Ready to terminate? Go here: http://localhost:6363/dashboard

## To stop, restart, attach, etc, see usage
```
$ ./terminus-container 

USAGE:
  terminus-container [COMMAND]

  help      show usage
  run       run container
  stop      stop container
  restart   restart container
  attach    attach to prolog shell
  stats     show container stats
```
Oh, and flattery motivates us, please give us a star here: https://github.com/terminusdb/terminus-server



