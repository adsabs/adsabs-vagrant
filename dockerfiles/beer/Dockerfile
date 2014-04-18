FROM     ubuntu:precise

#Bootstrap from minimal base machine
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install wget supervisor -y
RUN wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb --no-check-certificate
RUN dpkg -i puppetlabs-release-precise.deb
RUN apt-get update
RUN apt-get install -y puppet git
RUN mkdir /vagrant/
RUN git clone https://github.com/adsabs/adsabs-vagrant /vagrant/

#Application provisioning
RUN puppet apply /vagrant/manifests/site.pp

EXPOSE 8000

#Supervisord will take care of keeping services up (nginx+gunicorn)
ADD supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
