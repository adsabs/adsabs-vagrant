FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git supervisor bzip2 net-tools puppet curl nano nginx

RUN git clone https://github.com/adsabs/bumblebee
RUN puppet apply /bumblebee/manifests/site.pp

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD local-config.json /bumblebee/

# TODO: Unify configuration scheme for setting API and/or search backend
RUN sed -i "s/localhost/`netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}'`/g" /bumblebee/local-config.json
#RUN sed -i "s/localhost/`ip route | awk '/docker/ { print $NF }'`/g" /bumblebee/local-config.json

#Set up nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD bumblebee.nginx.conf /etc/nginx/sites-enabled/

ADD discovery.vars.js /bumblebee/src/discovery.vars.js
CMD ["/usr/bin/supervisord"]
