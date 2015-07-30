#!/bin/bash
# User-data for ecs clusters;
# Every instance in a cluster should have consul-agent, registrator, and logstash-forwarder 
# running on it.

IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
BRIDGE_IP="$(ip ro | awk '/^default/{print $3}')"
service docker start

docker run -d \
    --name consul \
    -h $HOSTNAME \  
    -p $IP:8300:8300 \
    -p $IP:8301:8301 \
    -p $IP:8301:8301/udp \       
    -p $IP:8302:8302 \
    -p $IP:8302:8302/udp \     
    -p $IP:8400:8400 \
    -p $IP:8500:8500 \
    -p $BRIDGE_IP:53 \
    -p $BRIDGE_IP:53:53/udp \
    --restart=always \
    progrium/consul \
    -advertise $IP -join consul.adsabs

docker run -d \
    --name logstash-forwarder \
    -v /tmp:/tmp \
    --restart=always \
    adsabs/logstash-forwarder

docker run -d \
    --name registrator
    -v /var/run/docker.sock:/tmp/docker.sock \
    --restart=always \
    -h $HOSTNAME \
    gliderlabs/registrator consul://