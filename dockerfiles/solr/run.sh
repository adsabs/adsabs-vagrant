#!/bin/bash

dns=`ip addr show eth0 | grep inet | grep eth0 | awk '{print $2}' | cut -d "/" -f -1`
docker build -t adsabs/solr .
for id in 1 2 3 4; do
  docker run -d -p $((8982+id)):8983 --name solr$id --dns $dns adsabs/solr
  docker start solr$id
done

#Assign container ips to host's /etc/hosts, then restart
sudo .././set_hosts.sh
for id in 1 2 3 4; do
  docker stop solr$id
  docker start solr$id
done