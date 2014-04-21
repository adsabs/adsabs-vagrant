#!/bin/bash

dns=`ip addr show eth0 | grep inet | grep eth0 | awk '{print $2}' | cut -d "/" -f -1`
docker build -t adsabs/solr .
for id in 1 2; do
  if [ $id = 1 ]; then
    docker run -d -p 8193:8193 --name solr$id --dns $dns adsabs/solr
  else
    docker run -d -p 8193:8194 --name solr$id --dns $dns adsabs/solr
  fi
done

sudo .././set_hosts.sh