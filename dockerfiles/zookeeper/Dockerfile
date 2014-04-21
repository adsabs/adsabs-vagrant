FROM ubuntu:precise

RUN apt-get update && apt-get install -y openjdk-7-jre-headless wget nano supervisor language-pack-en-base
ENV LC_ALL en_US.UTF-8

RUN wget -q -O /opt/zookeeper-3.4.6.tar.gz http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
RUN tar -xzf /opt/zookeeper-3.4.6.tar.gz -C /opt

RUN adduser vagrant --no-create-home --disabled-password --gecos ""
ADD zoo.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
ADD myid /zookeeper/myid
RUN chown -R vagrant:vagrant /zookeeper

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
#ENV JAVA_OPTS "-Xms256m -Xmx512m" #Set default java heap size, very important for good performance
ENV JMXDISABLE true

EXPOSE 2181 
EXPOSE 2888 3888

CMD ["/opt/zookeeper-3.4.6/bin/zkServer.sh","start-foreground"]