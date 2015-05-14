#!/usr/bin/env bash

#
# TODO Add crontab
# python aws_provisioner.py --update-dns adsabs
# healthcheck self?

yum install -y git docker-io

git clone https://github.com/adsabs/adsabs-aws /adsabs-aws
git clone https://github.com/adsabs/docker-consul /docker-consul

pushd /adsabs-aws
    python aws_provisioner.py --update-dns adsabs
popd

pushd /docker-consul
    service docker start
    docker build -t progrium/consul .
    IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    mkdir /data
    docker run -d -h consul-$HOSTNAME -v /data:/data \
        -p $IP:8300:8300 \
        -p $IP:8301:8301 \
        -p $IP:8301:8301/udp \
        -p $IP:8302:8302 \
        -p $IP:8302:8302/udp \
        -p $IP:8400:8400 \
        -p $IP:8500:8500 \
        -p 172.17.42.1:53:53/udp \
        --restart=always \
        --name consul-server \
        progrium/consul -server -advertise $IP -join consul.adsabs
popd
