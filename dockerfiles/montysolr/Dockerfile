FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget nano supervisor language-pack-en-base subversion git
RUN apt-get install -y --no-install-recommends openjdk-7-jdk ant
RUN update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
RUN update-alternatives --set javac /usr/lib/jvm/java-7-openjdk-amd64/bin/javac
ENV LC_ALL en_US.UTF-8

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
ENV ANT_HOME /usr/share/ant

RUN git clone https://github.com/romanchyla/montysolr.git /montysolr
RUN cd /montysolr && git checkout --force master && git fetch --tags
RUN cd /montysolr && git checkout --force `git describe --tags $(git rev-list --tags --max-count=1)`
RUN cd /montysolr && ant ivy-bootstrap && ant build-all

EXPOSE 8983

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD run.sh /montysolr/build/contrib/examples/adsabs/run.sh
CMD ["/usr/bin/supervisord"]
