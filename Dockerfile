FROM docker.io/ubuntu:14.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install \
    build-essential \
    git \
    python-setuptools \
    python-pip \
    python-dev \
    python-numpy \
    python-scipy \
    python-matplotlib \
    python-networkx \
    ipython && \
    pip install --upgrade pip && \
    apt-get install -y python-epydoc \
# python wireless dependencies
    libnl-dev \
    libnl1 \
    libssl-dev \
    libiw-dev \
    curl \
    libcurl3 \
    libcurl3-dev \
    wireless-tools \
    wget \
    vim \
    doxygen && \
# ethanol controller dependency (python)
    cd /tmp && \
    wget -c https://pypi.python.org/packages/source/c/construct/construct-2.5.2.tar.gz && \ 
    tar zxvf construct-2.5.2.tar.gz  && \
    cd construct-2.5.2 && \
    sudo ./setup.py install
