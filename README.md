# TF-Lite for AWS Lambda

The official wheels of TensorFlow-Lite don't work for AWS Lambda.
They only work for debian-based Linux distributions, like Ubuntu. 

To make it work for AWS Lambda, we need to recompile it for Amazon Linux,
which is a CentOS-based distribution.

In this repo, you'll find compiled binaries as well as the instructions 
for compiling it yourself.

## Using compiled TF-Lite

Go to the `tflite` folder to check the available python/TF versions and select the one you need.

Then use `pip` to install it:

```bash
https://github.com/alexeygrigorev/tflite-aws-lambda/blob/main/tflite/tflite_runtime-2.7.0-cp38-cp38-linux_x86_64.whl?raw=true
```

Note the `raw=true` at the end. Without it, pip will try to dowload the github page, not the actual wheel.

Latest available versions (as of 16 Nov 2023): 

* `v2.14.0` (for Python 3.10 and 3.11 only)
* `v2.7.0` (up to Python 3.9)
* `v2.6.2` (up to Python 3.9)
* `v2.5.2` (up to Python 3.9)
* `v2.4.4` (up to Python 3.9)



## Doing it in Docker

### Script 

Running it with one script:

```bash
PYTHON_VERSION=3.11
TENSORFLOW_VERSION=v2.14.0
./build_wheel_docker.sh ${PYTHON_VERSION} ${TENSORFLOW_VERSION}
```

### Runing without the script

Compiling it:

```bash
PYTHON_VERSION=3.11
TENSORFLOW_VERSION=v2.14.0

docker build \
    --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
    --build-arg TENSORFLOW_VERSION=${TENSORFLOW_VERSION} \
    -t tf-lite-lambda:${PYTHON_VERSION}-${TENSORFLOW_VERSION} \
    .
```

Extracting the wheel:

```bash
mkdir tflite

docker run --rm \
    -v $(pwd)/tflite:/tflite/results \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    tf-lite-lambda:${PYTHON_VERSION}-${TENSORFLOW_VERSION}
```


## Compiling TF-Lite

### Cloning TensorFlow Lite


Check for the up-to-date list here: https://github.com/tensorflow/tensorflow/releases

Clone the version you need:

```bash
TENSORFLOW_VERSION=v2.4.4
git clone --branch ${TENSORFLOW_VERSION} https://github.com/tensorflow/tensorflow.git
```

### Downloading the source code

Alternatively, you can download the source code and unpack it:

```bash
TENSORFLOW_VERSION=v2.4.4
wget https://github.com/tensorflow/tensorflow/archive/${TENSORFLOW_VERSION}.zip -O tensorflow.zip
unzip tensorflow.zip
mv tensorflow-* tensorflow
rm tensorflow.zip
```

That's faster than cloning


## Compiling TF-Lite

### Python 3.7

Installing Python: 

```bash
yum install -y python3.7 python3-devel

export PYTHON=python3.7
$PYTHON -m pip install -U pip
$PYTHON -m pip install numpy wheel pybind11
```

Compiling TF-Lite:

```bash
sh ./tensorflow/tensorflow/lite/tools/pip_package/build_pip_package.sh
```

The wheel will be located here:

```
./tensorflow/lite/tools/pip_package/gen/tflite_pip/python3.7/dist/tflite_runtime-2.4.4-cp37-cp37m-linux_x86_64.whl
```


### Python 3.8

Installing Python: 

```bash
amazon-linux-extras enable python3.8
yum install -y python38 python38-devel

export PYTHON=python3.8
$PYTHON -m pip install -U pip
$PYTHON -m pip install numpy wheel pybind11
```

Compiling TF-Lite:

```bash
sh ./tensorflow/tensorflow/lite/tools/pip_package/build_pip_package.sh
```

The wheel will be located here:

```
./tensorflow/lite/tools/pip_package/gen/tflite_pip/python3.8/dist/tflite_runtime-2.4.4-cp38-cp38-linux_x86_64.whl
```


### Python 3.9

Installing Python: 

```bash
yum install -y wget
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
bash Miniconda3-py39_4.10.3-Linux-x86_64.sh -b

export PATH=/root/miniconda3/bin/:$PATH
export PYTHON=python3.9

$PYTHON -m pip install -U pip
$PYTHON -m pip install numpy wheel pybind11
```

Compiling TF-Lite:

```bash
sh ./tensorflow/tensorflow/lite/tools/pip_package/build_pip_package.sh
```

The wheel will be located here:

```
./tensorflow/lite/tools/pip_package/gen/tflite_pip/python3.9/dist/tflite_runtime-2.4.4-cp39-cp39-linux_x86_64.whl
```


## Compiling Tensorflow Lite 2.7+ 

The process for compiling TF-Lite 2.7+ is more complex:

* Instead `PYTHON` you need to set `CI_BUILD_PYTHON` 
* You have to have cmake (check [install_cmake.sh](install_cmake.sh) to see how you can install it)
* Run `build_pip_package_with_cmake.sh` for installation, not `build_pip_package.sh`
* You need to have Numpy includes when you compile it ([this is how you do it](https://github.com/alexeygrigorev/tflite-aws-lambda/blob/6a5e3e5/build_wheel.sh#L13))
* You need a lot of RAM - around 24 GB. I ended up using an ec2 instance (`r5a.2xlarge`) for compiling it.


## Sources

* https://github.com/alexeygrigorev/serverless-deep-learning
* https://github.com/tpaul1611/python_tflite_for_amazonlinux
* https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/tools/pip_package/Dockerfile.py3
