# cups-docker
Docker container for old EPSON printers on basis of Debian Jessie.

Some friends of mine had an old EPSON printer for which no current drivers are available. 
So I decided to build a docker container which provides a CUPS server and the drivers for their printer. 
After all it would have been cheaper, if they just bought a new printer ;-) ...

But nevertheless I've had fun creating a solution and on the other hand it could also be helpful for others. 
It should be quite easy to modify the build script so that other printer drivers are included.

## Build the container images

Depending on your architecture you can either call
```
./build.sh i386 # creates cups-docker:epson-i386
```

or 
```
./build.sh amd64 # creates cups-docker:epson-amd64
```
From now on let's assume we're dealing with amd64 only.

## Using the image
The built image is self-contained in means of provides an interface that explains how to use it. 
```
docker run --rm -i cups-docker:epson-amd64
``` 
This results in:
```
cups-docker:epson-amd64 provides a CUPS server with drivers for all EPSON printer drivers located under:

    https://download.ebz.epson.net/dsc/op/stable/debian/dists/lsb3.2/main/

This image provides the following commands:

    start-cups                  The actual entry point to start the CUPS server 
                                in an container instance.
    container-handler           Dump a script that allows you to integrate the
                                CUPS server within your init system.
    help                        Print this help message.

Install and use cups-docker on your system as follows:

    docker run --rm -i cups-docker:epson-amd64 container-handler > cups-docker
    chmod +x cups-docker
    sudo ./cups-docker connect # after that restart your local CUPS
    ./cups-docker start

Now you can integrate 'cups-docker' with your init system or autostart it, when
you log in to your desktop environment.

```
When you read this output carefully and follow its steps everything should be clear and self-explaining.

## Docker images
See https://hub.docker.com/r/thednp/cups-docker for the built and released docker images.