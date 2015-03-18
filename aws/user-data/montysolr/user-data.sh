#!/bin/bash
yum update -y
yum install -y docker-io python27 python27-pip git ec2-net-utils
pip-2.7 install boto
service docker start

git clone https://github.com/adsabs/adsabs-aws /adsabs-aws
pushd /adsabs-aws
CLOUDID=`python27 aws_provisioner.py --get-instance-tag cloudid`
echo $CLOUDID > cloudid.txt #Only for logging purposes
python27 aws_provisioner.py --eni "cloudid:$CLOUDID"
sleep(5) #Configuring network interfaces can take a few seconds
python27 aws_provisioner.py --ebs "cloudid:$CLOUDID"
popd

git clone http://github.com/adsabs/adsabs-vagrant /adsabs-vagrant
pushd /adsabs-vagrant/dockerfiles/montysolr
aws s3 cp s3://adsabs-montysolr-etc/author_generated.translit author_generated.translit
aws s3 cp s3://adsabs-montysolr-etc/solrconfig_searcher.xml solrconfig.xml
docker build -t adsabs/montysolr .
docker run -d --name montysolr -p 8983:8983 -v /data:/data --net=host --restart=on-failure:3 adsabs/montysolr
popd
