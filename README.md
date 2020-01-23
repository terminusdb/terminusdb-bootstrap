```
████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗███████╗
╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔════╝
   ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║███████╗
   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║╚════██║
   ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝███████║
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
                                                                  
```

# TerminusDB Server Container Control

This is a simple convenience script to run terminus-server as a docker
container.

What the heck is TerminusDB? See here: https://terminusdb.com

## Prerequisites

### Docker

Since this script uses the TerminusDB Docker container, you need to have Docker
running.

On Windows and Mac, Docker Desktop can be downloaded here:
https://www.docker.com/products/docker-desktop

On Linux, use your distro's package manager, or find more information here:
https://www.docker.com/products/container-runtime

### Git

This script is distributed via GitHub, so you will need git to clone and update
it, if you don't already have git, you can download it here:
https://git-scm.com/downloads

Windows users should use the application "Git Bash" for all terminal commands
described below, this application comes with Git for Windows.

### Sudo

Sudo is optional. As letting unprivileged users run docker is insecure, this
script uses sudo by default if it is available. 

Most users will not need to do anything here, sudo is installed by default on
Macs and many populer Linux distros such as Fedora, Red Hat, Debian, Ubuntu and
Mint. Linux users who use minmal distros such as Archlinux, are advised to
install sudo and confugure their sudoers file accordingly.

Windows users do not need to do anything here.

## Get this script, cd to it

```
git clone https://github.com/terminusdb/terminus-quickstart
cd terminus-quickstart
```

## Run the container (the first time)

```
./terminus-container run

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

You may need to move or remove previous volumes or you may encounter bugs or
the old console.

Warning: This will lead to losing local data.

```
 ./terminus-container rm

removing will delete storage and config volumes
Are you sure? [y/N] y
terminus_storage
terminus-config
```

## Using the console

Ready to terminate? Open the TerminusDB Console in your web browser.

```
./terminus-container console
```

Or go here: http://localhost:6363/console

## To stop, attach, etc, see usage
```
./terminus-container 

USAGE:
  terminus-container [COMMAND]

  help        show usage
  run         run container
  stop        stop container
  console     launch console in web browser
  attach      attach to prolog shell
  stats       show container stats
  rm-config   remove config volume
  rm-storage  remove storage volume
  rm          remove volumes
```

That's it! You're ready to go!

Oh, and flattery motivates us, please give us a star here:
https://github.com/terminusdb/terminus-server

# Using The Enviroment

This script is designed to "work out of the box," however, there may be
situations where advanced users want to override some of it's defaults, this is
done by setting enviroment variables.

## Examples

### Mount a local directory inside the container
```
TERMINUS_LOCAL=/path/to/dir ./terminus-container [COMMAND]
```

### Using the latest release
```
TERMINUS_TAG=latest ./terminus-container [COMMAND]
```

### Using the development release
```
TERMINUS_TAG=dev ./terminus-container [COMMAND]
```

### Using a specific release instead of latest realease
```
TERMINUS_TAG=v1.1.1 ./terminus-container [COMMAND]
```

### Not using sudo even when sudo is available
```
TERMINUS_DOCKER=docker ./terminus-container [COMMAND]
```

### Using podman instead of docker command
```
TERMINUS_DOCKER="podman" ./terminus-container [COMMAND]
```

See the source code to find the other environment variables that can be set.



