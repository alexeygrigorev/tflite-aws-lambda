#!/usr/bin/env bash

PREFIX="./tensorflow/tensorflow/lite/tools/pip_package"

if [ -f "${PREFIX}/build_pip_package_with_cmake.sh" ]; then
    # we're in tensorflow 2.7 + 
    bash install_cmake.sh

    export CI_BUILD_PYTHON=${PYTHON}
    sh ${PREFIX}/build_pip_package_with_cmake.sh
else
    # we're in tensorflow 2.6 or older - no need to install cmake
    sh ${PREFIX}/build_pip_package.sh
fi