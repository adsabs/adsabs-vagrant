FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git bzip2 net-tools puppet curl nano python-pip python-dev libpq-dev
RUN pip install --upgrade pip gunicorn supervisor psycopg2

#Since these may be private github repos, assume that they are already cloned in this directory
RUN git clone -b vss https://github.com/adsabs/adsws /adsws

#Provision adsws
ADD adsws.local_config.py /adsws/instance/local_config.py
ADD discoverer.config /adsws/adsws/discoverer/config.py
WORKDIR /adsws
RUN pip install -r requirements.txt
RUN alembic upgrade head

#A better strategy should definitely deprecate this
ADD common.py.monkeypatch /usr/local/lib/python2.7/dist-packages/oauthlib/common.py

#Supervisord will take care of keeping services up
ADD gunicorn.conf.py /adsws/gunicorn.conf.py
ADD supervisord.conf /supervisord.conf

EXPOSE 80
CMD ["/usr/local/bin/supervisord","-c","/supervisord.conf"]

