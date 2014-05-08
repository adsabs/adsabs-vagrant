FROM     ubuntu:precise

#Bootstrap from minimal base machine
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install wget supervisor -y
RUN wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb --no-check-certificate
RUN dpkg -i puppetlabs-release-precise.deb
RUN apt-get update
RUN apt-get install -y puppet git
RUN mkdir -r /vagrant/manifests/
ADD manifests/* /vagrant/manifests/

#Application provisioning
RUN puppet apply /vagrant/manifests/site.pp

ADD local_config.py /proj/ads/adsabs/config/
EXPOSE 8000

#Supervisord will take care of keeping services up (nginx+gunicorn)
ADD supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
