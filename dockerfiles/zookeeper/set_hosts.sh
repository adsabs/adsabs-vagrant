#!/bin/bash
# An alternative to "links", run this script after starting or stopping any
# container. It's a hack to update the host machine (vagrant) /etc/hosts with
# the current active docker containers and tell dnsmasq to refresh.
#
# Then start each machine with "-dns ${DOCKER_HOST_IP}", e.g.
# $ docker run -d -name mycontainer1 -dns 10.0.3.1 MYPRODUCT
# You can't seem to set the DNS during "docker build".
#
# Diagnostic command to run in host or while logged into containers:
# # dig @10.0.3.1 mycontainer1
#
#https://gist.github.com/jamshid/7934004
cd ${0%/*}
 
function dip() { docker inspect $1 | grep IPAddress | cut -d '"' -f 4 ; }
 
cat /etc/hosts | grep -v '#DOCKER-DELETE-ME' > /etc/hosts.docker.tmp
RESULT="$?"
if [ ${RESULT} = 0 ]; then
echo "Checking for running docker containers..."
else
echo "Error modifying /etc/hosts, try running with sudo."
exit 1
fi
 
echo "# Below are the docker hosts running at $(date). #DOCKER-DELETE-ME" >> /etc/hosts.docker.tmp
 
 
docker ps | awk '{print $1}' | while read CONTAINERID
do
IP=$(dip ${CONTAINERID})
if [ -n "${IP}" ] ; then
NAME=$(docker inspect ${CONTAINERID} | grep Name | cut -d '"' -f 4 | sed 's#^/##g')
echo "${IP} ${NAME} #DOCKER-DELETE-ME" >> /etc/hosts.docker.tmp
fi
done

dnsmasq
mv -f /etc/hosts.docker.tmp /etc/hosts
killall -HUP dnsmasq
echo 'Updated /etc/hosts with current ("docker ps") entries...'
tail -10 /etc/hosts









# #!/bin/bash

# echo "127.0.0.1       localhost
# 127.0.1.1       ubuntu-12.04.3-amd64-vbox       ubuntu-12

# # The following lines are desirable for IPv6 capable hosts
# ::1     ip6-localhost ip6-loopback
# fe00::0 ip6-localnet
# ff00::0 ip6-mcastprefix
# ff02::1 ip6-allnodes
# ff02::2 ip6-allrouters" > /etc/hosts

# for ZK_ID in 1 2 3; do

#   ip=`docker inspect zookeeper$ZK_ID | grep IPAddress | awk '{print $2}' | tr -d '",\n'`
#   echo "$ip zookeeper$ZK_ID" >> /etc/hosts

# done
