FROM ubuntu:precise

RUN apt-get update && apt-get install -y openjdk-7-jre-headless wget nano supervisor language-pack-en-base
ENV LC_ALL en_US.UTF-8

RUN wget -nv -O /opt/solr-4.8.0.tgz http://download.nextag.com/apache/lucene/solr/4.8.0/solr-4.8.0.tgz
RUN tar -xzf /opt/solr-4.8.0.tgz -C /opt
RUN mkdir -p /opt/solr-4.8.0/example/tmp #Jetty acts strangely if it doesn't have tmp/ within jetty.home

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
#ENV JAVA_OPTS "-Xms256m -Xmx512m" #Set default java heap size, very important for good performance

ADD schema.xml /opt/solr-4.8.0/example/solr/collection1/conf/schema.xml

EXPOSE 8983

CMD ["java","-DnumShards=2","-Dsolr.solr.home=/opt/solr-4.8.0/example/solr","-Djetty.home=/opt/solr-4.8.0/example","-Dbootstrap_confdir=/opt/solr-4.8.0/example/solr/collection1/conf","-Dcollection.configName=foobar","-DzkHost=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181","-jar","/opt/solr-4.8.0/example/start.jar"]