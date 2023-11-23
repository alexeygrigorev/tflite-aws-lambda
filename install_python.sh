#!/usr/bin/env bash

set -e

echo "PYTHON_VERSION=${PYTHON_VERSION}"

if [ "${PYTHON_VERSION}" == "3.7" ]; then
    yum install -y python3.7 python3-devel
    exit 0
fi

if [ "${PYTHON_VERSION}" == "3.8" ]; then
    amazon-linux-extras enable python3.8
    yum install -y python38 python38-devel
    exit 0
fi

if [ "${PYTHON_VERSION}" == "3.9" ]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
    bash Miniconda3-py39_4.10.3-Linux-x86_64.sh -b
    ln -s /root/miniconda3/bin/python3.9 /bin/python3.9
    exit 0
fi

if [ "${PYTHON_VERSION}" == "3.10" ]; then
    ARCH=`uname -i`
    wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.9.0-0-Linux-${ARCH}.sh
    bash Miniconda3-py310_23.9.0-0-Linux-${ARCH}.sh -b
    ln -s /root/miniconda3/bin/python3.10 /bin/python3.10
    exit 0
fi

if [ "${PYTHON_VERSION}" == "3.11" ]; then
    ARCH=`uname -i`
    wget https://repo.anaconda.com/miniconda/Miniconda3-py311_23.9.0-0-Linux-${ARCH}.sh
    bash Miniconda3-py311_23.9.0-0-Linux-${ARCH}.sh -b
    ln -s /root/miniconda3/bin/python3.11 /bin/python3.11
    exit 0
fi

echo "Unknown python version PYTHON_VERSION=${PYTHON_VERSION}"
exit 1