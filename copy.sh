#!/usr/bin/env bash

PREFIX=./tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/${PYTHON}/dist
cp $PREFIX/*.whl ./results/

