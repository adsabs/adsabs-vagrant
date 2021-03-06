#!/bin/bash
# User-data for ecs clusters;
# Every instance in a cluster should have consul-agent, registrator, and logstash-forwarder 
# running on it.

echo "ECS_CLUSTER=staging" > /etc/ecs/ecs.config
IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4 | tr -d '\n'`
BRIDGE_IP="$(ip ro | awk '/docker0/{print $9}')"

service docker restart

# This will remove the ability to query route53
#echo "prepend  domain-name-servers $BRIDGE_IP;" >> /etc/dhcp/dhclient.conf
#dhclient -r; dhclient

docker stop ecs-agent
docker start ecs-agent

docker run -d \
    --name consul  \
    -h $HOSTNAME \
    -p $IP:8300:8300 \
    -p $IP:8301:8301 \
    -p $IP:8301:8301/udp \
    -p $IP:8302:8302 \
    -p $IP:8302:8302/udp \
    -p $IP:8400:8400 \
    -p $IP:8500:8500 \
    -p $BRIDGE_IP:53:53 \
    -p $BRIDGE_IP:53:53/udp \
    --restart=always progrium/consul \
    -advertise $IP \
    -join consul.adsabs

docker run -d \
    --name logstash-forwarder \
    -v /tmp:/tmp \
    --restart=always \
    adsabs/logstash-forwarder

docker run -d \
    --name registrator \
    -v /var/run/docker.sock:/tmp/docker.sock \
    --restart=always \
    --hostname=$HOSTNAME \
    gliderlabs/registrator -ip $IP -resync 10 consul://$IP:8500