FROM amazonlinux

RUN yum groupinstall -y development
RUN yum install -y wget

WORKDIR /tflite

ARG TENSORFLOW_VERSION

# RUN git clone --branch ${TENSORFLOW_VERSION} https://github.com/tensorflow/tensorflow.git 
RUN wget https://github.com/tensorflow/tensorflow/archive/${TENSORFLOW_VERSION}.zip -O tensorflow.zip \
    && unzip tensorflow.zip \
    && mv tensorflow-* tensorflow \
    && rm tensorflow.zip

COPY install_python.sh . 

ARG PYTHON_VERSION
RUN bash install_python.sh

ENV PYTHON python${PYTHON_VERSION}
RUN echo $PYTHON

RUN $PYTHON -m pip install -U pip
RUN $PYTHON -m pip install numpy wheel pybind11

RUN sh ./tensorflow/tensorflow/lite/tools/pip_package/build_pip_package.sh
RUN mv ./tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/${PYTHON}/dist/*.whl .

COPY copy.sh . 

ENTRYPOINT [ "bash", "copy.sh" ]