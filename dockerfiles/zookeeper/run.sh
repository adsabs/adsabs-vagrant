#!/bin/bash

#Target: adsabs-vagrant (pure devel environment)

dns=`ip addr show eth0 | grep inet | grep eth0 | awk '{print $2}' | cut -d "/" -f -1`
for ZK_ID in 1 2 3; do

  echo $ZK_ID > myid

  docker build -t adsabs/zookeeper$ZK_ID .
  docker run -d --name zookeeper$ZK_ID --dns $dns --hostname zookeeper$ZK_ID adsabs/zookeeper$ZK_ID
  docker stop zookeeper$ZK_ID

  rm myid
done

for ZK_ID in 1 2 3; do
  docker start zookeeper$ZK_ID
done
sudo .././set_hosts.sh
