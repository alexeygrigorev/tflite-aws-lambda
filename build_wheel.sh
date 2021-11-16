#!/usr/bin/env bash

PREFIX="./tensorflow/tensorflow/lite/tools/pip_package"

if [ -f "${PREFIX}/build_pip_package.sh" ]; then
    # we're in tensorflow 2.6 or older - no need to install cmake
    sh ${PREFIX}/build_pip_package.sh
else
    if [ -f "${PREFIX}/build_pip_package_with_cmake.sh" ]; then
        # we're in tensorflow 2.7+
        bash install_cmake.sh

        NUMPY_DIR=`$PYTHON -c "import numpy; import os.path; print(os.path.dirname(numpy.__file__))"`
        INCLUDES=`${PYTHON} -c "from sysconfig import get_paths as gp; print(gp()['include'])"`
        ln -sf ${NUMPY_DIR}/core/include/numpy ${INCLUDES}/numpy

        export CI_BUILD_PYTHON=${PYTHON}
        sh ${PREFIX}/build_pip_package_with_cmake.sh
    fi
fi