#!/bin/bash

#Target: adsabs-vagrant (pure devel environment)

# p=2888
for ZK_ID in 1 2 3; do
  echo $ZK_ID > myid
  # p1=$((p+1))
  # p2=$((p1+1000))

  # sed -i "s/$p/$p1/g" Dockerfile
  # sed -i "s/$((p+1000))/$p2/g" Dockerfile


  docker build -t adsabs/zookeeper$ZK_ID .
  if [ $ZK_ID = 1 ]; then
    docker run -d --name zookeeper$ZK_ID -p 2181:2181 adsabs/zookeeper$ZK_ID
  else
    docker run -d --name zookeeper$ZK_ID adsabs/zookeeper$ZK_ID
  fi
  # sed -i "s/$p1/$p/g" Dockerfile
  # sed -i "s/$p2/$((p+1000))/g" Dockerfile
  # rm myid
  # p=$p1
done