FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git bzip2 net-tools puppet curl nano python-pip python-dev libpq-dev
RUN pip install --upgrade pip gunicorn supervisor psycopg2

WORKDIR /apps
RUN git clone https://github.com/adsabs/recommender_service
RUN git clone https://github.com/adsabs/metrics_service
RUN git clone https://github.com/adsabs/graphics_service
RUN git clone https://github.com/adsabs/citation_helper_service

WORKDIR /apps/recommender_service
RUN git pull && git reset --hard f87795bf63636d9b35745e6dcd1e7f26fd94e137
RUN pip install -r requirements.txt
ADD gunicorn.conf.py.recommender_service /apps/recommender_service/gunicorn.conf.py
ADD local_config.py.recommender_service /apps/recommender_service/recommender/local_config.py

WORKDIR /apps/metrics_service
RUN git pull && git reset --hard 083b589067ab39fd7d7e0ce2cb16569bd81985c6
RUN pip install -r requirements.txt
ADD gunicorn.conf.py.metrics_service /apps/metrics_service/gunicorn.conf.py
ADD local_config.py.metrics_service /apps/metrics_service/metrics/local_config.py


WORKDIR /apps/graphics_service
RUN git pull && git reset --hard d80df5cb4a62fba5ff74bbbb85f1cf0f02240fd2
RUN pip install -r requirements.txt
ADD gunicorn.conf.py.graphics_service /apps/graphics_service/gunicorn.conf.py
ADD local_config.py.graphics_service /apps/graphics_service/graphics/local_config.py


WORKDIR /apps/citation_helper_service
RUN git pull && git reset --hard dcb05f937ba2395aa3d20257e4d8d2676c3235b1
RUN pip install -r requirements.txt
ADD gunicorn.conf.py.citation_helper_service /apps/citation_helper_service/gunicorn.conf.py
ADD local_config.py.citation_helper_service /apps/citation_helper_service_service/citation_helper/local_config.py


#Supervisord will take care of keeping services up
ADD supervisord.conf /supervisord.conf

EXPOSE 80 81 82 83

CMD ["/usr/local/bin/supervisord","-c","/supervisord.conf"]
