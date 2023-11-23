#!/usr/bin/env bash

set -e

ARCH=`uname -i`
mkdir /opt/cmake

if [ "${ARCH}" == "x86_64" ]; then
    wget https://github.com/Kitware/CMake/releases/download/v3.16.8/cmake-3.16.8-Linux-x86_64.sh
    sh cmake-3.16.8-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
    exit 0
fi

if [ "${ARCH}" == "aarch64" ]; then
    #wget https://github.com/Kitware/CMake/releases/download/v3.27.8/cmake-3.27.8-linux-aarch64.sh
    #sh cmake-3.27.8-linux-aarch64.sh --prefix=/opt/cmake --skip-license
    wget https://cmake.org/files/v3.19/cmake-3.19.3-Linux-aarch64.sh
    sh cmake-3.19.3-Linux-aarch64.sh --prefix=/opt/cmake --skip-license
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
    exit 0
fi

echo "unknown architecture ${ARCH}"
exit 1
