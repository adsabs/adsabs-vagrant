FROM     ubuntu:precise

#Bootstrap from minimal base machine
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget build-essential python-dev subversion libxml2-dev libxslt-dev libatlas-base-dev python-pip ant git libmysqlclient-dev language-pack-en-base
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
RUN python montysolrupdate.py --no-virtualenv -u
RUN python montysolrupdate.py --no-virtualenv -u -c live-3000

EXPOSE 3000

#Supervisord will take care of keeping services up (nginx+gunicorn)
#CMD ["/usr/bin/supervisord"]