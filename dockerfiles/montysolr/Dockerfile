FROM     ubuntu:precise

#Bootstrap from minimal base machine
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget build-essential python-dev subversion libxml2-dev libxslt-dev libatlas-base-dev python-pip ant git libmysqlclient-dev language-pack-en-base supervisor
RUN update-locale LC_ALL=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN pip install pip --upgrade

#Java needs access to host's /dev/fuse in a postinit script
RUN fakeroot apt-get install -y openjdk-7-jdk

#Bootstrap montysolr with updatemontysolr.py
RUN mkdir -p /var/lib/montysolr
RUN git clone https://github.com/vsudilov/montysolr.git /var/lib/montysolr/
RUN ln -s /var/lib/montysolr/contrib/examples/src/python/montysolrupdate.py /montysolrupdate.py
RUN python montysolrupdate.py --no-virtualenv -p -j -y
RUN python montysolrupdate.py --no-virtualenv -u -c live-9000

EXPOSE 9000

#Supervisord will take care of keeping services up
ADD supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord"]
