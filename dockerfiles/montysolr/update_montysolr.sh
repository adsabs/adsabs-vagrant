#!/bin/bash

# Update script for montysolr on AWS. This script should be run via cron.

# This clone on montysolr is used only for fetching/describing tags;
# it will be re-cloned within the docker container at build time
get_git_tag () {
    pushd /montysolr
        git fetch --tags
        TAG=`git describe --tags $(git rev-list --tags --max-count=1)`
        LAST_TAG=`cat latest_tag.txt`

        TAG_MINOR=`python -c "s='$TAG';sp=s.split('.');print '.'.join(sp[3:])"`
        LAST_TAG_MINOR=`python -c "s='$LAST_TAG';sp=s.split('.');print '.'.join(sp[3:])"`

        if [ "$TAG_MINOR" == "$LAST_TAG_MINOR" ]; then
            exit 0
        fi

        echo $TAG > latest_tag.txt
        echo `date` " Found new latest tag $TAG" >> /tmp/deployments.log
    popd
}

# Function that attemps to download config from s3
# with the suffix `.$TAG`. If no file is downloaded, default
# to the base filename
download_config () {
    FILE_LIST="author_generated.translit solrconfig.xml"
    for FILE in $FILE_LIST;
    do
        aws s3 cp s3://adsabs-montysolr-etc/$FILE.$TAG $FILE
        if [ ! -f $FILE ]; then
            echo `date` " No $FILE.$TAG found. Defaulting to $FILE" >> /tmp/deployments.log
            aws s3 cp s3://adsabs-montysolr-etc/$FILE $FILE
        fi
    done
}


# Upgrade the solr docker container on localhost, rolling back
# to the previous tag if unresponsive for 900 seconds
upgrade_localhost () {
    docker stop montysolr
    docker rm montysolr
    docker run -d --name montysolr -p 8983:8983 -v /data:/data -v /tmp/:/montysolr/build/contrib/examples/adsabs/logs/ --restart=on-failure:3 adsabs/montysolr:$TAG
    counter_localhost=0
    while true; do
        STATUS_LOCALHOST=`curl -I -m 3 "http://localhost:8983/solr/select?q=star&rows=1&fl=id" | head -n 1 | cut -d$' ' -f2`
        if [ ! -z "$STATUS" ]; then
            if [ $STATUS == 200 ]; then
                exit 0
            fi
        fi
    sleep 30
    counter_localhost=$((counter_localhost+1))
    if [[ $counter_localhost -gt 30 ]]; then # Rollback if we've polled for 900s without success
        echo `date` " upgrade_localhost failure: unresponsive > 900s. Init rollback to $LAST_TAG" >> /tmp/deployments.log
        docker stop montysolr
        docker rm montysolr
        docker run -d --name montysolr -p 8983:8983 -v /data:/data -v /tmp/:/montysolr/build/contrib/examples/adsabs/logs/ --restart=on-failure:3 adsabs/montysolr:$LAST_TAG
        echo `date` " rollback container to $LAST_TAG complete" >> /tmp/deployments.log
        rollback_config
        exit 1
    fi
    done
}

# Rolls back the config to LAST_TAG
rollback_config () {
    pushd /montysolr
        echo $LAST_TAG > latest_tag.txt
        TAG=$LAST_TAG
    popd
    pushd /adsabs-vagrant/dockerfiles/montysolr
        download_config
    popd
    echo `date` " rollback config to $LAST_TAG complete" >> /tmp/deployments.log
}

pushd /adsabs-vagrant/dockerfiles/montysolr
    get_git_tag
    download_config
    sed -i 's/TAG=""/TAG='"$TAG"'/' checkout_tag.sh
    docker build -t adsabs/montysolr:$TAG .
    git checkout checkout_tag.sh

    # Identify the remote peer that is also a solr searcher
    pushd /adsabs-aws/
        CLOUDID=`python27 aws_provisioner.py --get-instance-tag cloudid`
        PARTNER_IP=`python27 aws_provisioner.py --find-partner-instance-private-ip "cloudid:$CLOUDID"`
    popd
    if [ -z "$PARTNER_IP" ]; then
        echo `date` " Could not find a partner with cloudid:$CLOUDID. Abort" >> /tmp/deployments.log
        rollback_config
        exit 1
    fi

    # If the remote peer is responsive, start the upgrade process on localhost
    # The first step of the local upgrade process makes localhost unresponsive,
    # therefore minimizing the chance that both services upgrade at the same time
    counter_partner=0
    while true; do
        STATUS=`curl -I -m 3 "http://$PARTNER_IP:8983/solr/select?q=star&rows=1&fl=id" | head -n 1 | cut -d$' ' -f2`
        if [ ! -z "$STATUS" ]; then
            if [ $STATUS == 200 ]; then
                upgrade_localhost
            fi
        fi
        sleep 30
        counter_partner=$((counter_partner+1))
        if [[ $counter_partner -gt 30 ]]; then # Don't attempt a local upgrade if the partner is unresponsive for 900s
            echo `date` " Waited >900s for remote partner $PARTNER_IP to becomes responsive. Abort." >> /tmp/deployments.log
            rollback_config
            exit 1
        fi
    done
popd
