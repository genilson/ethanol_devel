# Development container #

This repository contains a Dockerfile that can be used to build an Ubuntu 14.04 image which contains all the tools and dependencies that are necessary to develop the Ethanol controller and agents. This image can than be used to create containers in which the ethanol_controller and ethanol_hostapd repositories can be cloned.

# Installation #

## Docker installation ##

Docker can be installed through your system's package manager. On Debian based systems just run the command:

```bash
sudo apt-get install -y docker.io
```

## Ethanol devel container ##

Containers must be as ephemeral as possible, which means that destroying and recreating them must not result in data loss. So, no code should be modified inside a container, but rather stored somewhere in the docker host file system and than made available for the container to access. Then, let's (1) clone the ethanol_controller repo in your home directory, (2) configure ethanol to run with pox, (3) clone the ethanol_hostapd repo in your home directory, (4) build the docker imagem from the Dockerfile available in this repo, (5) from the base image, create and run the ethanol_controller container mounting the ethanol_controller cloned folder into it, (6) from the base image, create and run the ethanol_hostapd container mounting the ethanol_hostapd cloned folder into it. I'm using the root user, change the absolute paths if you're using a different one.

```bash
cd ~ && git clone https://github.com/genilson/ethanol_controller.git
cd ~/ethanol_controller/ && bash configure.sh
cd ~ && git clone https://github.com/genilson/ethanol_hostapd.git
docker build -t ethanol_base github.com/genilson/ethanol_devel.git
docker run -it --name ethanol_ap -w /home/ethanol_hostapd --network host --cap-add=NET_ADMIN --mount type=bind,source=/root/ethanol_hostapd/,target=/home/ethanol_hostapd ethanol_base
docker run -it --name ethanol_ap -w /home/ethanol_hostapd --network host --mount type=bind,source=~/ethanol_hostapd/,target=/home/ethanol_hostapd ethanol_base
```

You can add another bind mount for the .ssh folder in the Docker host so you can use git both from the docker host or the container.

The options --cap-add and --network respectively allow the container to perform varios network operations (for instance, hostapd will not be able to ifup and ifdown network interfaces without it) and exposes the docker host network stack to the container (does not isolate it, so network interfaces, IP addresses, etc., inside the container are seen just like they are seen in the docker host).

After completing these steps you can make changes locally on the code and those changes will be visible inside the container (and vice-versa) for testing.

If you want to use two different hosts for the controller and the AP, there's no need to build the image again, just export it to the other host, load it on Docker and follow steps 5 or 6 to create the container:

```bash
docker save -o <path for generated tar file> <image name>
scp generated_tar_file user@remotehost:/home/user
docker load -i <path to image tar file>
```

The controller communicates with the APs through messages. A certificate file is used to provide secure communication. You can use your own certificate, just copy the .pem file to ethanol_controller/ethanol/ssl_message/ on the controller and to ethanol_hostapd/hostapd-2.6/src/messaging/ on the APs.

Follow instructions available in the [ethanol_hostapd repository](https://github.com/genilson/ethanol_hostapd) to compile hostapd. Bellow is an overview of what you need to get everything working (remember commands are executed inside the respective container):

## Running hostapd ##

To run Ethanol's hostapd you need to put in the same directory the following files:
* the modified version of hostapd -- this file is generated after compilation in the [hostadp directory of this repository](https://github.com/genilson/ethanol_hostapd/tree/master/hostapd-2.6/hostapd).
```bash
cd /home/ethanol_hostapd/hostapd-2.6/hostapd
make clean
make ethanol
```
* the certificate -- As mentioned above, you can use your own certificate or ours, which are already configured.
* the modified version of iw -- You will find the source code in [iw-4.9 directory](https://github.com/genilson/ethanol_hostapd/tree/master/iw-4.9) just compile it and move it to the ethanol folder.
```bash
cd /home/ethanol_hostapd/iw-4.9/
make clean
make ethanol
cp iw /home/ethanol_hostapd/hostapd-2.6/hostapd
```
* ethanol.ini -- this file should be copied to /etc directory. A sample file can be found in [src/ini](https://github.com/genilson/ethanol_hostapd/tree/master/hostapd-2.6/src/ini) directory in this repository.
* hostapd.conf -- this is the configuration file of hostapd. You will find a [sample file in this repository](https://github.com/genilson/ethanol_hostapd/blob/master/hostapd-2.6/hostapd/hostapd.conf).

After making sure that everything is compiled and put in the right places run:
```bash
$ sudo hostapd ./hostapd.conf
```
## Running Ethanol Controller ##
Just run:
```bash
cd /home/ethanol_controller/pox
python pox.py forwarding.l2_learning log.level --DEBUG ethanol.server
```
