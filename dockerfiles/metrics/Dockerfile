FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git bzip2 net-tools puppet curl nano python-pip python-dev libpq-dev
RUN pip install --upgrade pip gunicorn supervisor psycopg2

RUN git clone https://github.com/adsabs/metrics_service /app
WORKDIR /app
RUN git pull && git reset --hard 5e3958b3dcd3eb292eeeeee2

ADD local_config.py /app/
RUN pip install -r requirements.txt

#Supervisord will take care of keeping services up
ADD gunicorn.conf.py /app/
ADD supervisord.conf /supervisord.conf

EXPOSE 80

CMD ["/usr/local/bin/supervisord","-c","/supervisord.conf"]
