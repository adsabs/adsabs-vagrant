#!/bin/bash

service mongodb restart
if [ ! -f /.mongo_inititalized ];
then
  echo "Init mongo auth"
  mongo < /adsabs/mongo_auth.js
  touch  /.mongo_inititalized
  sleep 10
fi 

pushd /adsabs
gunicorn -c gunicorn.conf.py entry:application
popd
