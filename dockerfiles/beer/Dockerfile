FROM     ubuntu:precise

#Bootstrap from minimal base machine
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget -y
RUN wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb --no-check-certificate
RUN dpkg -i puppetlabs-release-precise.deb
RUN apt-get update
RUN apt-get install -y puppet git
RUN git clone -b vss https://github.com/adsabs/adsabs-vagrant

#Application provisioning
RUN mkdir -p /vagrant/
RUN mv /adsabs-vagrant/* /vagrant/
RUN puppet apply /vagrant/manifests/site.pp

EXPOSE 5000 8000

#Supervisord will take care of keeping services up (nginx+gunicorn)
#CMD ["/usr/bin/supervisord"]
