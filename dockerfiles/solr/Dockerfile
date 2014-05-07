FROM ubuntu:precise

RUN apt-get update && apt-get install -y openjdk-7-jre-headless wget nano supervisor language-pack-en-base
ENV LC_ALL en_US.UTF-8

RUN wget -nv -O /opt/solr-4.8.0.tgz http://download.nextag.com/apache/lucene/solr/4.8.0/solr-4.8.0.tgz
RUN tar -xzf /opt/solr-4.8.0.tgz -C /opt
RUN mkdir -p /opt/solr-4.8.0/example/tmp #Jetty acts strangely if it doesn't have tmp/ within jetty.home

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ADD schema.xml /opt/solr-4.8.0/example/solr/collection1/conf/schema.xml
ADD run.sh /run.sh

EXPOSE 8983

CMD ["bash","/run.sh"]
