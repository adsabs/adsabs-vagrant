FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git supervisor bzip2 net-tools puppet curl nano

RUN git clone -b vss-deploy https://github.com/adsabs/bumblebee /vagrant/
RUN puppet apply /vagrant/manifests/site.pp

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD local-config.json /vagrant/

# TODO: Unify configuration scheme for setting API and/or search backend
RUN sed -i "s/localhost/`netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}'`/g" /vagrant/local-config.json
RUN sed -i "s/localhost/`netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}'`/g" /vagrant/app.py

ADD discovery.vars.js /vagrant/src/discovery.vars.js
CMD ["/usr/bin/supervisord"]
