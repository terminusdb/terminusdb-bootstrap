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
$ git clone https://github.com/terminusdb/terminus-quickstart
$ cd terminus-quickstart
```

## Run the container (the first time)

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

## If you've installed before 

You may need to move or remove previous volumes or you may encounter bugs or the old console.

```
sudo docker volume rm terminus_config
sudo docker volume rm terminus_storage
```

## Using the console

Ready to terminate? 

```
$ ./terminus_container console
```

Or go here: http://localhost:6363/console

## To stop, attach, etc, see usage
```
$ ./terminus-container 
USAGE:
  terminus-container [COMMAND]

  help      show usage
  run       run container
  stop      stop container
  console   launch console in web browser
  attach    attach to prolog shell
  stats     show container stats
  rm        remove container and volumes
```
Oh, and flattery motivates us, please give us a star here: https://github.com/terminusdb/terminus-server



