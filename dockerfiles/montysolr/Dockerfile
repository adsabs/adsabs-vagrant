FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget nano supervisor language-pack-en-base subversion git curl psmisc
RUN apt-get install -y --no-install-recommends openjdk-7-jdk ant
RUN update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
RUN update-alternatives --set javac /usr/lib/jvm/java-7-openjdk-amd64/bin/javac
ENV LC_ALL en_US.UTF-8

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
ENV ANT_HOME /usr/share/ant

RUN git clone https://github.com/romanchyla/montysolr.git /montysolr
COPY checkout_tag.sh /montysolr/checkout_tag.sh
WORKDIR /montysolr
RUN bash checkout_tag.sh #Responsible for checking out the correct tag
RUN ant ivy-bootstrap && ant build-all

WORKDIR /montysolr/build/contrib/examples/adsabs/
COPY author_generated.translit /montysolr/build/contrib/examples/adsabs/solr/collection1/conf/author_generated.translit
COPY turn-into-slave.py turn-into-slave.py
RUN python turn-into-slave.py

EXPOSE 8983
VOLUME /data
RUN mkdir -p /data/batch-handler

#Supervisord will take care of keeping services up
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY healthcheck.sh /montysolr/build/contrib/examples/adsabs/healthcheck.sh
COPY run.sh /montysolr/build/contrib/examples/adsabs/run.sh
CMD ["/usr/bin/supervisord"]
