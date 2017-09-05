FROM docker.io/ubuntu:14.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install build-essential && \
    apt-get -y install python-setuptools python-pip python-dev && \
    apt-get -y install python-numpy python-scipy python-matplotlib python-networkx ipython
RUN pip install --upgrade pip 

# python wireless dependencies
RUN apt-get install -y libnl-dev libnl1 libssl-dev libiw-dev curl libcurl3 libcurl3-dev
RUN apt-get install -y wireless-tools
RUN apt-get install -y wget

# ethanol controller dependency (python)
RUN cd /tmp && \
    wget -c https://pypi.python.org/packages/source/c/construct/construct-2.5.2.tar.gz && \\
    tar zxvf construct-2.5.2.tar.gz && \
    cd construct-2.5.2 && \
    sudo ./setup.py install

# clone ethanol repository

