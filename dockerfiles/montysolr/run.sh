#!/bin/bash

#If this script is run in the AWS environment, H and shardID will be set by the provisioner. Do not set these manually.
H=""
shardId=""
#Dedicate some% of the physical ram to the java heap
ram=`awk '/MemTotal/{print $2}' /proc/meminfo`
xmx=`python -c "print int($ram/1024.0*0.60)"`
xms=`python -c "print int($ram/1024.0*0.50)"`

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
  -Xmx${xmx}m \
  -Xms${xms}m \
  -Dorg.eclipse.jetty.server.Request.maxFormContentSize=9000000 \
  -Dsolr.solr.home=$HOMEDIR/solr \
  -Dsolr.data.dir=/data \
  -Dpython.path=$JYTHONPATH \
  -Djetty.home=$HOMEDIR \
  -Djute.maxbuffer=100000000 \
  -Dmontysolr.reuseCache=false \
  -Dmontysolr.batch.workdir=/data/batch-handler \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:+PrintGC \
  -XX:+PrintGCDetails \
  -XX:+PrintGCTimeStamps \
  -Xloggc:$HOMEDIR/logs/mem.log \
  -jar start.jar
else
java \
  -Xmx${xmx}m \
  -Xms${xms}m \
  -Dhost=$H \
  -DzkClientTimeout=95000 \
  -Dorg.eclipse.jetty.server.Request.maxFormContentSize=9000000 \
  -DshardId=$shardId \
  -Dshard=$shardId \
  -Dsolr.data.dir=/data \
  -DnumShards=1 \
  -Dsolr.solr.home=$HOMEDIR/solr \
  -Dpython.path=$JYTHONPATH \
  -Djetty.home=$HOMEDIR \
  -DzkHost=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
  -Djute.maxbuffer=100000000 \
  -Dmontysolr.reuseCache=false \
  -Dmontysolr.batch.workdir=/data/batch-handler \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:+PrintGC \
  -XX:+PrintGCDetails \
  -XX:+PrintGCTimeStamps \
  -Xloggc:$HOMEDIR/logs/mem.log \
  -jar start.jar
fi
