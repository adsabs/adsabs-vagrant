FROM adsabs/montysolr

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD run.sh /montysolr/build/contrib/examples/adsabs/run.sh
CMD ["/usr/bin/supervisord"]
