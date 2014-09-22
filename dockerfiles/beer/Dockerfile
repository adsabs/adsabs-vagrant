FROM     ubuntu:14.04

RUN apt-get update
RUN apt-get install -y git nano curl wget supervisor nginx gunicorn python-dev python-pip libxml2-dev libxslt1-dev python-lxml
RUN pip install --upgrade pip

RUN git clone https://github.com/vsudilov/adsabs
RUN cd /adsabs && pip install -r requirements.txt

#Supervisord will take care of keeping services up (nginx+gunicorn)
ADD supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
