FROM ubuntu:trusty


RUN apt-get update
RUN apt-get install -y git supervisor bzip2 net-tools puppet curl nano nginx python-pip python-dev
RUN pip install --upgrade pip


#Since these may be private github repos, assume that they are already cloned in this directory
ADD bumblebee /bumblebee
ADD adsws /adsws


#Provision bumblebee
RUN puppet apply /bumblebee/manifests/site.pp
ADD discovery.vars.js /bumblebee/src/discovery.vars.js
#####Please remove for "real" production
RUN sed -i 's/use_debugger=True/use_debugger=False/g' /adsws/wsgi.py 


#Provision adsws
ADD adsws.local_config.py /adsws/instance/local_config.py
ADD alembic.ini /adsws/alembic.ini
RUN cd /adsws && pip install -r requirements.txt
RUN cd /adsws && alembic upgrade head


#Set up nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD adsws.nginx.conf /etc/nginx/sites-enabled/


#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord"]
