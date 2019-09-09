#Dockerfile for face-recognition
#Based on https://github.com/denverdino/face_recognition_pi

FROM resin/raspberry-pi-python:3
COPY pip.conf /root/.pip/pip.conf
RUN apt-get -y update
RUN apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-dev \
    libavcodec-dev \
    libavformat-dev \
    libboost-all-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    zip \
    i2c-tools \
    python-pil \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*
RUN CFLAGS=-std=c99 python3 -m ensurepip --upgrade && CFLAGS=-std=c99 pip3 install --upgrade picamera[array] dlib

RUN git clone --single-branch https://github.com/BLavery/lib_oled96.git

RUN git clone --single-branch https://github.com/ageitgey/face_recognition.git

RUN cd /face_recognition && \
    pip3 install Cython && \
    pip3 install --no-build-isolation -r requirements.txt && \
    python3 setup.py install

RUN cd /lib_oled96.git && \
    pip install smbus && \
    pip3 install smbus2

CMD cd /face_recognition/examples && \
    python3 recognize_faces_in_pictures.py

