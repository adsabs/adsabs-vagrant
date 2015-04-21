#!/bin/bash

yum install -y git docker python27 python27-pip
pip-2.7 install boto

# Function that attemps to download config from s3
# with the suffix .$TAG. If no file is downloaded, default
# to the base filename
download_config () {
    FILE_LIST="author_generated.translit solrconfig.xml"
    for FILE in $FILE_LIST;
    do
        aws s3 cp s3://adsabs-montysolr-etc/$FILE.$TAG $FILE
        if [ ! -f $FILE ]; then
            aws s3 cp s3://adsabs-montysolr-etc/$FILE $FILE
        fi
    done
}

# This clone on montysolr is used only for fetching/describing tags;
# it will be re-cloned within the docker container at build time
get_git_tag () {
    if [ ! -d "/montysolr" ]; then
        git config --global user.name "anon"
        git config --global user.email "anon@anon.com"
        git clone https://github.com/romanchyla/montysolr /montysolr
    fi
    pushd /montysolr
        git fetch --tags
        TAG=`git describe --tags $(git rev-list --tags --max-count=1)`
        if [ ! -f "latest_tag.txt" ]; then
            echo $TAG > latest_tag.txt
            echo `date` " Found $TAG" >> /tmp/deployments.log
        fi
    popd
}


# Find this instance's cloudid and attach the EBS associated with this cloudid
git clone https://github.com/adsabs/adsabs-aws /adsabs-aws
pushd /adsabs-aws
    CLOUDID=`python27 aws_provisioner.py --get-instance-tag cloudid`
    python27 aws_provisioner.py --ebs "cloudid:$CLOUDID"
    if [ -f "/data/index/write.lock" ]; then
        rm /data/index/write.lock
    fi
popd

git clone https://github.com/adsabs/adsabs-vagrant /adsabs-vagrant
pushd /adsabs-vagrant/dockerfiles/montysolr
    get_git_tag
    download_config
    service docker start
    docker build -t adsabs/montysolr:$TAG .
    docker run -d --name montysolr -p 8983:8983 -v /data:/data -v /tmp/:/montysolr/build/contrib/examples/adsabs/logs/ --restart=on-failure:3 adsabs/montysolr:$TAG
    (crontab -l ; echo "*/30 * * * * /adsabs-vagrant/dockerfiles/montysolr/update_montysolr.sh") | crontab
popd




# notes
#amzn-ami-hvm-2015.03.0.x86_64-gp2 (ami-1ecae776) #docker build breaks on jcc
#amzn-ami-hvm-2014.09.2.x86_64-ebs - ami-146e2a7c
