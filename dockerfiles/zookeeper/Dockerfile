FROM ubuntu:precise

RUN apt-get update && apt-get install -y openjdk-7-jre-headless wget nano supervisor language-pack-en-base
ENV LC_ALL en_US.UTF-8

RUN wget -q -O /opt/zookeeper-3.4.6.tar.gz http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
RUN tar -xzf /opt/zookeeper-3.4.6.tar.gz -C /opt

ADD zoo.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
ADD zookeeper-env.sh /opt/zookeeper-3.4.6/conf/zookeeper-env.sh
ADD myid /zookeeper/myid

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
#ENV JAVA_OPTS "-Xms256m -Xmx512m" #Set default java heap size, very important for good performance
ENV JMXDISABLE true

EXPOSE 2181 2888 3888

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD zk.sh /zk.sh
CMD ["/usr/bin/supervisord"]
#CMD ["/opt/zookeeper-3.4.6/bin/zkServer.sh","start-foreground"]
