```

████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗██╗   ██╗███████╗██████╗ ██████╗ 
╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██║   ██║██╔════╝██╔══██╗██╔══██╗
   ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║██║   ██║███████╗██║  ██║██████╔╝
   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██║   ██║╚════██║██║  ██║██╔══██╗
   ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║╚██████╔╝███████║██████╔╝██████╔╝
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚═════╝ ╚═════╝ 

```

# TerminusDB Server Container Control

This is a simple convenience script to run terminusdb-server as a docker
container.

What the heck is TerminusDB? See here: https://terminusdb.com

## Table of Contents

* [Prerequisites](#Prerequisites)
  * [Docker](#Docker)
  * [Git](#Git)
  * [Sudo](#Sudo)
* [Installing](#Installing)
  * [Get the repo](#Get-this-repo-cd-to-it)
  * [Run the container by using the script](#Run-the-container-by-using-the-script-the-first-time)
  * [Using the console](#Using-the-console)
  * [To stop, attach, etc, see usage](#To-stop-attach-etc-see-usage)
* [Using The Enviroment](#Using-The-Enviroment)
  * [Security](#Security)
  * [`ENV` File](#ENV-file)
  * [`ENV` Examples](#ENV-Examples)
* [Using Docker Compose](#Using-Docker-Compose)

## Prerequisites

### Docker

Since this script uses the TerminusDB Docker container, you need to have Docker
running.

On Windows and Mac, Docker Desktop can be downloaded here:
https://www.docker.com/products/docker-desktop

Note that on Windows, the default memory allowed for Docker is 2GB. Since this
is an in-memory database, bigger databases require more memory. Therefore
raise the default allowed memory usage to a higher value in the Docker Desktop
settings.

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

## Installing

### Get this repo, cd to it

```
git clone https://github.com/terminusdb/terminusdb-bootstrap
cd terminusdb-bootstrap
```

### Run the container by using the script (the first time)

```
./terminusdb-container run

Unable to find image 'terminusdb/terminusdb-server:latest' locally
latest: Pulling from terminusdb/terminusdb-server
8f91359f1fff: Pulling fs layer
939634dec138: Pulling fs layer
f30474226dd6: Pulling fs layer
32a63113e3ae: Pulling fs layer
ae35de9092ce: Pulling fs layer
023c02983955: Pulling fs layer
d9fa4a1acf93: Pulling fs layer
[ ... ]
```

#### If you've installed before

You may need to remove previous volumes or you may encounter bugs or
the old console.

Warning: This will lead to losing local data.

```
 ./terminusdb-container rm

This will delete storage volume
Are you sure? [y/N] y
```

### Using the console

Ready to terminate? Open the TerminusDB Console in your web browser.

```
./terminusdb-container console
```

Or go here: http://localhost:6363/

### To stop, attach, etc, see usage
```
./terminusdb-container 

USAGE:
  terminusdb-container [COMMAND]

  help        show usage
  run         run container
  stop        stop container
  console     launch console in web browser
  attach      attach to prolog shell
  exec        execeute a command inside the container
  rm          remove volumes
```

That's it! You're ready to go!

Oh, and flattery motivates us, please give us a star here:
https://github.com/terminusdb/terminusdb-server

# Using The Enviroment

This script is designed to "work out of the box," however, there may be
situations where advanced users want to override some of it's defaults, this is
done by setting enviroment variables.

## Security

TerminusDB Bootstrap has HTTPS turned off by default to avoid scary security
warnings since it's impossible to responsibly provide a valid SSL certificate
for localhost.

To prevent accidental insecure deployments, the Docker container binds to the
IP 127.0.0.1 and therefore the server will only be accessible on the local
machine, and not from any other machine over the network.

If you would like to deploy to a server, you will need to enable HTTPS, and
then accept the browser security warning about the self signed cert.

You can enable HTTPS with the `TERMINUSDB_HTTPS_ENABLED` environment
variable.

```
TERMINUSDB_HTTPS_ENABLED=true ./terminusdb-container run
```

This will work out of the box using the self-signed cert that ships with
TerminusDB Server. However, this certificate will require that you accept the
certificate as it is considered insecure by your browser.

To eliminate the browser security warning so that you do not need to accept the
certificate, simply provide a valid certificate and set the path to the cert
and key with environment variables like in this example:

```
TERMINUSDB_HTTPS_ENABLED=true
TERMINUSDB_SSL_CERT=/etc/letsencrypt/live/example.com/fullchain.pem
TERMINUSDB_SSL_CERT_KEY=/etc/letsencrypt/live/example.com/privkey.pem
```

To make your server available across the network you will also need to set `TERMINUSDB_AUTOLOGIN` to false

```
TERMINUSDB_AUTOLOGIN=false
```

## `ENV` File

The script sources a file called `ENV` if it is found in the current directory.
See [`ENV.example`] for examples of the environment variables that can be set.

[`ENV.example`]: ./ENV.example

To have environment variables set every time you run `./terminusdb-container`,
follow these steps:

1. Copy `ENV.example` to `ENV`.
2. Edit `ENV`: uncomment the lines you want to change and set the values.

## ENV reference

| ENV name                    | Default value                                                               | Purpose                                                       |
|-----------------------------|-----------------------------------------------------------------------------|---------------------------------------------------------------|
| TERMINUSDB_DOCKER           | sudo docker                                                                 | Default docker command                                        |
| TERMINUSDB_CONTAINER        | terminusdb-server                                                           | Name of the running container                                 |
| TERMINUSDB_REPOSITORY       | terminusdb/terminusdb-server                                                | Docker image                                                  |
| TERMINUSDB_NETWORK          | bridge                                                                      | Docker network mode                                           |
| TERMINUSDB_TAG              | The latest version tag of terminusdb-server                                 | TerminusDB docker image version                               |
| TERMINUSDB_STORAGE          | terminusdb_storage_local                                                    | Storage volume name                                           |
| TERMINUSDB_PORT             | 6363                                                                        | Port to run TerminusDB                                        |
| TERMINUSDB_LOCAL            |                                                                             | Local folder to mount inside container                        |
| TERMINUSDB_SERVER           | 127.0.0.1                                                                   | Server on which TerminusDB will run                           |
| TERMINUSDB_PASS             | root                                                                        | Password for accessing TerminusDB                             |
| TERMINUSDB_AUTOLOGIN        | false                                                                       | Whether the administration console should automatically login |
| TERMINUSDB_CONSOLE          | http://127.0.0.1/console                                                    | URL for browser top open console                              |
| TERMINUSDB_CONSOLE_BASE_URL | https://unpkg.com/@terminusdb/terminusdb-console@SOME_VERSION/console/dist/ | URL to hosted console                                         |
| TERMINUSDB_HTTPS_ENABLED    | false                                                                       | Enable HTTPS                                                  |
| TERMINUSDB_SSL_CERT         | A self signed cert                                                          | Path to SSL cert inside terminusdb-server container           |
| TERMINUSDB_SSL_CERT_KEY     | A self-created private key                                                  | Path to private key for SSL cert inside container             |

## Examples

These are examples of environment variables you can set when running
`./terminusdb-container`.

### Mount a local directory inside the container
```
TERMINUSDB_LOCAL=/path/to/dir ./terminusdb-container [COMMAND]
```

### Set the Docker Volume name
```
TERMINUSDB_STORAGE=terminus_storage_local ./terminusdb-container [COMMAND]
```

### Using the latest release
```
TERMINUSDB_TAG=latest ./terminusdb-container [COMMAND]
```

### Using the development release
```
TERMINUSDB_TAG=dev ./terminusdb-container [COMMAND]
```

### Using a specific release instead of latest realease
```
TERMINUSDB_TAG=v1.1.2 ./terminusdb-container [COMMAND]
```

### Using a local version of  TerminusDB Console instead of the published version
```
TERMINUSDB_CONSOLE_BASE_URL=//127.0.0.1:3005 ./terminusdb-container [COMMAND]
```

### Not using sudo even when sudo is available
```
TERMINUSDB_DOCKER=docker ./terminusdb-container [COMMAND]
```

### Using podman instead of docker command
```
TERMINUSDB_DOCKER="podman" ./terminusdb-container [COMMAND]
```

See the source code to find the other environment variables that can be set.

