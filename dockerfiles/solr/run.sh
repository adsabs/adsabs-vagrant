#!/bin/bash

#If this script is run in the AWS environment, H will be set by the provisioner. Do not set it manually.
H=""

if [ -z "$H" ]
then
java \
  -DnumShards=2 \
  -Dsolr.solr.home=/opt/solr-4.8.0/example/solr \
  -Djetty.home=/opt/solr-4.8.0/example \
  -Dbootstrap_confdir=/opt/solr-4.8.0/example/solr/collection1/conf \
  -Dcollection.configName=foobar \
  -DzkHost=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
  -jar /opt/solr-4.8.0/example/start.jar
else
java \
  -Dhost=$H \
  -DnumShards=2 \
  -Dsolr.solr.home=/opt/solr-4.8.0/example/solr \
  -Djetty.home=/opt/solr-4.8.0/example \
  -Dbootstrap_confdir=/opt/solr-4.8.0/example/solr/collection1/conf \
  -Dcollection.configName=foobar \
  -DzkHost=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
  -jar /opt/solr-4.8.0/example/start.jar
fi