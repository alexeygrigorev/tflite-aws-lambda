#!/usr/bin/env bash

set -e

PYTHON_VERSION=$1
TENSORFLOW_VERSION=$2

echo PYTHON_VERSION=${PYTHON_VERSION}
echo TENSORFLOW_VERSION=${TENSORFLOW_VERSION}

docker build \
    --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
    --build-arg TENSORFLOW_VERSION=${TENSORFLOW_VERSION} \
    -t tf-lite-lambda:${PYTHON_VERSION}-${TENSORFLOW_VERSION} \
    .

mkdir -f tflite

docker run --rm \
    -v $(pwd)/tflite:/tflite/results \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    tf-lite-lambda:${PYTHON_VERSION}-${TENSORFLOW_VERSION}

echo DONE