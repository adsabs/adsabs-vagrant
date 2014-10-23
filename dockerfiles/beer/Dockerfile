FROM     ubuntu:14.04

RUN apt-get update
RUN apt-get install -y git nano curl wget supervisor gunicorn python-dev python-pip libxml2-dev libxslt1-dev python-lxml openjdk-7-jre mongodb
RUN pip install --upgrade pip

RUN git clone -b vss https://github.com/adsabs/adsabs
RUN cd /adsabs && pip install -r requirements.txt
ADD local_config.py /adsabs/config/local_config.py
ADD mongo_auth.js /adsabs/mongo_auth.js
RUN cd /adsabs && /usr/bin/mongod --dbpath /var/lib/mongodb/ --smallfiles --fork --logpath /dev/null && mongo < mongo_auth.js

#Supervisord will take care of keeping services up (nginx+gunicorn)
ADD supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
