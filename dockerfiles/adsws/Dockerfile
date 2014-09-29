FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git bzip2 net-tools puppet curl nano python-pip python-dev
RUN pip install --upgrade pip gunicorn supervisor

#Since these may be private github repos, assume that they are already cloned in this directory
ADD adsws /adsws

#Provision adsws
ADD adsws.local_config.py /adsws/instance/local_config.py
ADD alembic.ini /adsws/alembic.ini
RUN cd /adsws && pip install -r requirements.txt
RUN cd /adsws && alembic upgrade head
RUN sed -i "s/localhost/`netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}'`/g" /adsws/instance/local_config.py

#Supervisord will take care of keeping services up
ADD gunicorn.conf.py /adsws/gunicorn.conf.py
ADD supervisord.conf /supervisord.conf

CMD ["/usr/local/bin/supervisord","-c","/supervisord.conf"]

