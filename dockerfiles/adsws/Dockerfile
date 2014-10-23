FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git bzip2 net-tools puppet curl nano python-pip python-dev libpq-dev
RUN pip install --upgrade pip gunicorn supervisor psycopg2

#We can't rely on link containers during build time, and we can't rely on connecting
#via the docker interface->host because of how the HEAD network is set up =(
#As a result, the IP of the postgres service will have to be manually maintined via
#`docker inspect postgresql | grep IP`
ENV POSTGRESQL_PORT_5432_TCP_ADDR 172.17.0.6
ENV POSTGRESQL_PORT_5432_TCP_PORT 5432

#Since these may be private github repos, assume that they are already cloned in this directory
ADD adsws /adsws

#Provision adsws
ADD adsws.local_config.py /adsws/instance/local_config.py
ADD alembic.ini /adsws/alembic.ini
RUN cd /adsws && pip install -r requirements.txt
RUN cd /adsws && alembic upgrade head

#Not necessary and won't work anyways, see note about postgresql above.
#RUN sed -i "s/localhost/`netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}'`/g" /adsws/instance/local_config.py

#A better strategy should definitely deprecate this
ADD common.py.monkeypatch /usr/local/lib/python2.7/dist-packages/oauthlib/common.py

#Supervisord will take care of keeping services up
ADD gunicorn.conf.py /adsws/gunicorn.conf.py
ADD supervisord.conf /supervisord.conf

CMD ["/usr/local/bin/supervisord","-c","/supervisord.conf"]

