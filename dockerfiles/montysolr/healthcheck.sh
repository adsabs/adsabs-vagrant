#!/bin/bash
## Check the heartbeat of localhost. If it fails a certain number of healthchecks, kill -9
## The solr processes; assume supervisord will restart them as well as this script if that
## is done

sleep 30 # Sleep some time before entering the mainloop to give solr time to start
counter=0
while true; do
    STATUS=`curl -I -m 2 "http://localhost:8983/" | head -n 1 | cut -d$' ' -f2`
    if [ -z "$STATUS" ]; then
      counter=$((counter+1))
    else
      counter=0
    fi
    sleep 3
    if [[ $counter -gt 3 ]]; then 
      killall -9 java
      killall -9 run.sh
      exit 0
    fi
done