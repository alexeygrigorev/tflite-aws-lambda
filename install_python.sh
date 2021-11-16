#!/usr/bin/env bash

if [ "${PYTHON_VERSION}" == "3.7" ]; then
    yum install -y python3.7 python3-devel
fi

if [ "${PYTHON_VERSION}" == "3.8" ]; then
    amazon-linux-extras enable python3.8
    yum install -y python38 python38-devel
fi

if [ "${PYTHON_VERSION}" == "3.9" ]; then
    yum install -y wget
    wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
    bash Miniconda3-py39_4.10.3-Linux-x86_64.sh -b
    ln -s /root/miniconda3/bin/python3.9 /bin/python3.9
fi
