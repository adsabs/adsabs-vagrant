#!/bin/bash

#If this script is run in the AWS environment, H and shardID will be set by the provisioner. Do not set these manually.
H=""
shardId=""

HOMEDIR=/montysolr/build/contrib/examples/adsabs          
export PYTHONPATH=/montysolr/build/dist:/montysolr/src/python:
export JYTHONPATH=$HOMEDIR/jython

#          For reference (not needed by MontySOLR)
# export JCC_CP="${prop.jcc_egg}"
# export JAVA_CP="$HOMEDIR/lib/ext/jcl-over-slf4j-1.7.6.jar:$HOMEDIR/lib/ext/jul-to-slf4j-1.7.6.jar:$HOMEDIR/lib/ext/log4j-1.2.16.jar:$HOMEDIR/lib/ext/slf4j-api-1.7.6.jar:$HHOMEDIR/jython"
# export CP="$JCC_CP:$JAVA_CP"

if [ -z "$H" ]
then
java \
  -DnumShards=2 \
  -Dsolr.solr.home=$HOMEDIR/solr \
  -Dsolr.data.dir=/data \
  -Dpython.path=$JYTHONPATH \
  -Djetty.home=$HOMEDIR \
  -Dbootstrap_confdir=$HOMEDIR/solr/collection1/conf \
  -Dcollection.configName=adsabs_solr_config \
  -DzkHost=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
  -Djute.maxbuffer=100000000 \
  -jar start.jar
else
java \
  -Dhost=$H \
  -DshardId=$shardId \
  -Dsolr.data.dir=/data \
  -DnumShards=2 \
  -Dsolr.solr.home=$HOMEDIR/solr \
  -Dpython.path=$JYTHONPATH \
  -Djetty.home=$HOMEDIR \
  -Dbootstrap_confdir=$HOMEDIR/solr/collection1/conf \
  -Dcollection.configName=adsabs_solr_config \
  -DzkHost=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
  -Djute.maxbuffer=100000000 \
  -jar start.jar
fi
