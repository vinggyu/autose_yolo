FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        git \
        wget \
        gcc \
        g++ \
        make && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home

RUN git clone https://github.com/pjreddie/darknet && \
    cd darknet && \
    make -j"$(nproc)" && \
    wget https://data.pjreddie.com/files/yolov3.weights

RUN printf '%s\n' \
'#!/usr/bin/env bash' \
'wget -q -O /tmp/input.jpg "$1"' \
'cd /home/darknet' \
'./darknet detect cfg/yolov3.cfg yolov3.weights /tmp/input.jpg' \
> /usr/local/bin/run_yolo.sh && chmod +x /usr/local/bin/run_yolo.sh

ENTRYPOINT ["/usr/local/bin/run_yolo.sh"]
