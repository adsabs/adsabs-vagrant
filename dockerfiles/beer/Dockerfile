FROM     ubuntu:14.04

RUN apt-get update
RUN apt-get install -y git nano curl wget supervisor gunicorn python-dev python-pip libxml2-dev libxslt1-dev python-lxml openjdk-7-jre mongodb
RUN pip install --upgrade pip

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Install MongoDB
RUN apt-get update
RUN apt-get install -y mongodb-org numactl

# Create the MongoDB data directory
RUN mkdir -p /data/db
VOLUME /data/

RUN git clone -b vss https://github.com/adsabs/adsabs
RUN cd /adsabs && pip install -r requirements.txt
ADD local_config.py /adsabs/config/local_config.py
ADD mongo_auth.js /adsabs/mongo_auth.js
ADD run.sh /run.sh

ADD supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
