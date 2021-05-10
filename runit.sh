#!/bin/bash
# if you need more echos : set -x #echo on 

# specifiy number of memcached threads here :
# num_threads = 1 

# if error : x509: certificate signed by unknown authority]
# exectute : export no_proxy=$no_proxy,*.docker.internal

#enter yes to jump to the next step directly
echo "cluster already set? (y/n) [default: no]"
read ans 

if [[ "$ans" != "y" ]]; then

   echo "enter ID [default: moeschp]"
   read ans

   id="moeschp"
   if [[ "$ans" != "" ]]; then
      echo "you entered $ans"
      id=$ans
   fi

   export KOPS_STATE_STORE=gs://cca-eth-2021-group-20-$id/
   export KOPS_FEATURE_FLAGS=AlphaAllowGCE
 
   echo "start gcloud ? (y/n) [default: yes]"
   read ans 

   if [[ "$ans" != "n" ]]; then
      #echo "sudo gcloud init"
      sudo gcloud init
   fi

   #gcloud auth application-default login

   echo "Empty and refill Gcloud bucket ? (y/n) [default: yes]"
   read ans 

   if [[ "$ans" != "n" ]]; then
      echo "gsutil rm -r $KOPS_STATE_STORE"
      gsutil rm -r $KOPS_STATE_STORE
      echo "gsutil mb $KOPS_STATE_STORE"
      gsutil mb $KOPS_STATE_STORE
   fi

   echo "CREATING CLUSTER"
   PROJECT='glcoud config get-value project'
   echo "kops create -f part4.yaml"
   kops create -f part4.yaml
   echo "kops update cluster --name part4.k8s.local --yes --admin"
   kops update cluster --name part4.k8s.local --yes --admin
   echo "kops validate cluster --wait 10m"
   kops validate cluster --wait 10m
fi

echo parsing cluster data...

#sudo kubectl get nodes -o wide
t=$(sudo kubectl get nodes -o wide)
ips=$(echo "$t" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
ips=($ips)

# External and internal IP's, if necessary
internal_agent=${ips[0]}
external_agent=${ips[1]}
internal_measure=${ips[2]}
external_measure=${ips[3]}
internal_master=${ips[4]}
external_master=${ips[5]}
internal_memcache=${ips[6]}
external_memcache=${ips[7]}

# specific VM name
clientdat=($(echo "$t" | grep 'agent'))
agent_name=${clientdat[0]}
measure_name=($(echo "$t" | grep 'measure'))
memdat=($(echo "$t" | grep 'memcache'))
memcache_name=${memdat[0]}
masterat=($(echo "$t" | grep 'master'))
master_name=${masterat[0]}

echo "$agent_name with external IP : $external_agent"
echo "$measure_name with external IP : $external_measure"
echo "$memcache_name with external IP : $external_memcache"
echo "$master_name with external IP : $external_master"

# Quit if you only needed to set up a cluster
echo "CLUSTER READY, continue ? (y/n) [default: yes]"
read ans
if [[ "$ans" != "n" ]]; then
    exit
fi

## install memcached on the memcache-server
echo "connection to memcache server..."
gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@memcache_name --zone europe-west3-a
echo "update and install memcache"
sudo apt update
sudo apt install -y memcached libmemcached-tools
echo "modyfing configuration file"
sudo sed -i "s/^-m.*/-m ${1024}/"  /etc/memcached.conf
sudo sed -i "s/^-l.*/-l ${internal_memcache}/"  /etc/memcached.conf
#sudo sed -i "s/^-t.*/-t ${num_threads}/"  /etc/memcached.conf
sudo systemctl restart memcached

echo "memcached running"
read ok
## client measure

# send the set
gcloud compute scp --zone europe-west3-a setup_dyn_memc.sh root@client-measure-vchb:/home/ubuntu --ssh-key-file ~/.ssh/cloud-computing  
gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@client-measure-vchb --zone europe-west3-a

# remove if you are using Unix
sudo apt install dos2unix
sudo dos2unix setup_dyn_memc.sh

sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt-get update

sudo bash setup_dyn_mems.sh

cd memcache-perf-dynamics
sudo make
