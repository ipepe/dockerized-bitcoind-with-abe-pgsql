#!/usr/bin/env bash


if [ "x$1" = "x" ] ; then
    echo "Please give a name of container"
else
    echo docker build -t ipepe/$1 ./src
    docker build -t ipepe/$1 ./src

    echo docker run -d --name $1 -h $1 --restart=unless-stopped -i -t -P -v /opt/docker/$1/data:/data ipepe/$1
    docker run -d --name $1 -h $1 --restart=unless-stopped -i -t -P -v /opt/docker/$1/data:/data ipepe/$1
fi
