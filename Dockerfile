FROM docker.io/ubuntu:14.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install build-essential git && \
    apt-get -y install python-setuptools python-pip python-dev && \
    apt-get -y install python-numpy python-scipy python-matplotlib python-networkx ipython
RUN pip install --upgrade pip 
RUN apt-get install -y python-epydoc

# python wireless dependencies
RUN apt-get install -y libnl-dev libnl1 libssl-dev libiw-dev curl libcurl3 libcurl3-dev
RUN apt-get install -y wireless-tools
RUN apt-get install -y wget
RUN apt-get install -y doxygen

# ethanol controller dependency (python)
RUN cd /tmp && \
    wget -c https://pypi.python.org/packages/source/c/construct/construct-2.5.2.tar.gz && \ 
    tar zxvf construct-2.5.2.tar.gz  && \
    cd construct-2.5.2 && \
    sudo ./setup.py install

# clone ethanol repository
RUN mkdir -p /home/ethanol && \
    cd /home/ethanol && \
    git clone https://github.com/h3dema/ethanol_controller.git && \
    cd ethanol_controller && \
    bash configure.sh

RUN cd /home/ethanol && \
    git clone https://github.com/h3dema/ethanol_hostapd.git && \
    cd ethanol_hostapd

RUN cd /home/ethanol && \
    cp ethanol_hostapd/certificate/mycert.pem ethanol_controller/ethanol/ssl_message/ &&
    cp ethanol_hostapd/certificate/mycert.pem ethanol_hostapd/hostapd-2.6/src/messaging/

