# Development container #

This repository contains a dockerfile that creates a docker container with all tools and code needed to develop the Ethanol controller and agents.

# Installation #

## Docker installation ##

The installation of Docker is easy in Ubuntu 14.04 or latter.
Just issue the command:

```bash
sudo apt-get install -y docker.io
```

## Ethanol devel container ##

The following commands (1) download, install and configure the container with all tools and codes, and (2) starts the container, changing to the working directory (/home/ethanol).

```bash
docker build -t ethanol github.com/h3dema/ethanol_devel.git
docker run -w /home/ethanol -it ethanol
```


# More info #

This docker container provides:

* Ethanol's dependencies (downloaded and installed by Dockerfile)
* Ethanol agent -- a modified hostapd and some helper utilities (see [ethanol_hostapd](https://github.com/h3dema/ethanol_hostapd))
* Ethanol controller -- a POX module that implements Ethanol's architecture (see [ethanol_controller](https://github.com/h3dema/ethanol_controller))
