#!/bin/bash

dns=`ip addr show eth0 | grep inet | grep eth0 | awk '{print $2}' | cut -d "/" -f -1`

if [ ! -e "Dockerfile.origin" ]; then
mv Dockerfile Dockerfile.origin
fi

for id in 1 2 3 4; do
  shard=$((id%2+1))
  sed "s/1\/*/$shard\/*/g" Dockerfile.vagrantbuild > Dockerfile
  sed -i "s/H=\"\"/H=montysolr$id/g" run.sh
  sed -i "s/shardId=\"\"/shardId=$shard/g" run.sh

  docker build -t adsabs/montysolr$id .
  docker run -d -p $((8982+id)):8983 --name montysolr$id --dns $dns adsabs/montysolr$id
  docker start montysolr$id
done
