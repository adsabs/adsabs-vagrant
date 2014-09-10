FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git supervisor bzip2 net-tools puppet curl nano nginx python-pip
RUN pip install --upgrade pip

#Since these may be private github repos, assume that they are already cloned in this directory
ADD bumblebee /bumblebee
ADD adsws /adsws

#Provision bumblebee
RUN puppet apply /bumblebee/manifests/site.pp

#Provision adsws
RUN cd /adsws && pip install -r requirements.txt
ENV PYTHONPATH /adsws
RUN cd /adsws && alembic upgrade head

#Set up local config
ADD discovery.vars.js /bumblebee/src/discovery.vars.js

#####Please remove for "real" production
RUN sed -i 's/use_debugger=True/use_debugger=False/g' /adsws/wsgi.py 

#Add nginx conf files
ADD nginx.conf /etc/nginx.conf
ADD adsws.nginx.conf /etc/nginx/sites-enabled/

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord"]
