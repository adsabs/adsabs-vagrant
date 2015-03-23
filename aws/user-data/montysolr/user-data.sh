#!/bin/bash
yum update -y
yum install -y docker-io python27 python27-pip git ec2-net-utils
pip-2.7 install boto

git clone https://github.com/adsabs/adsabs-aws /adsabs-aws
pushd /adsabs-aws
CLOUDID=`python27 aws_provisioner.py --get-instance-tag cloudid`
echo $CLOUDID > cloudid.txt #Only for logging purposes
python27 aws_provisioner.py --eni "cloudid:$CLOUDID"
sleep 10 #Configuring network interfaces can take a few seconds
echo "METRIC=20002" >> /etc/sysconfig/network-scripts/ifcfg-eth0
service network restart
sleep 2
python27 aws_provisioner.py --ebs "cloudid:$CLOUDID"
popd

git clone http://github.com/adsabs/adsabs-vagrant /adsabs-vagrant
pushd /adsabs-vagrant/dockerfiles/montysolr
aws s3 cp s3://adsabs-montysolr-etc/author_generated.translit author_generated.translit
aws s3 cp s3://adsabs-montysolr-etc/solrconfig_searcher.xml solrconfig.xml
service docker start
docker build -t adsabs/montysolr:init .
docker run -d --name montysolr -p 8983:8983 -v /data:/data --restart=on-failure:3 adsabs/montysolr:init
popd