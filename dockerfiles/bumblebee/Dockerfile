FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git supervisor bzip2 net-tools puppet curl nano nginx

RUN git clone https://github.com/adsabs/bumblebee /bumblebee
ADD shim.html /bumblebee/src/shim.html
ADD discovery.vars.js.default /bumblebee/src/discovery.vars.js.default
WORKDIR /bumblebee
RUN puppet apply manifests/site.pp

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD local-config.json /bumblebee/

#Set up nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD bumblebee.nginx.conf /etc/nginx/sites-enabled/

EXPOSE 80

CMD ["/usr/bin/supervisord"]
