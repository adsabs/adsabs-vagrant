#!/bin/bash

yum update -y
yum install -y docker-io python27 python27-pip git ec2-net-utils
pip-2.7 install boto

git clone -b refactor https://github.com/adsabs/adsabs-aws /adsabs-aws
pushd /adsabs-aws
CLOUDID=`python27 aws_provisioner.py --get-instance-tag cloudid`
echo $CLOUDID > cloudid.txt #Only for logging purposes
python27 aws_provisioner.py --eni "cloudid:$CLOUDID"
sleep(5) #Configuring network interfaces can take a few seconds
popd

git clone http://github.com/adsabs/adsabs-vagrant /adsabs-vagrant
pushd /adsabs-vagrant/dockerfiles/montysolr
wget -O author_generated.translit S3_URL
docker build -t adsabs/montysolr:initial .
docker run -d --name montysolr -p 8983:8983 -v /data:/data --restart=on-failure:3 adsabs/montysolr:initial
popd
