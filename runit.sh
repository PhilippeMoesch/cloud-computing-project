#!/bin/bash

sudo gcloud init
#gcloud auth application-default login
export KOPS_STATE_STORE=gs://cca-eth-2021-group-20-moeschp/
export KOPS_FEATURE_FLAGS=AlphaAllowGCE
PROJECT = 'glcoud config get-value project'
kops create -f part4.yaml
kops update cluster --name part4.k8s.local --yes --admin
kops validate cluster --wait 10m
t=$(kubectl get nodes -o wide)
ips=$(echo "$t" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
ips=($ips)
internal_agent=${ips[0]}
external_agent=${ips[1]}
internal_measure=${ips[2]}
external_measure=${ips[3]}
internal_master=${ips[4]}
external_master=${ips[5]}
internal_memcache=${ips[6]}
external_memcache=${ips[7]}

## install memcached on the memcache-server

read ok

## client measure

scp setup_dyn_memc.sh root@($external_measure):/home/ubuntu -i ~/.ssh/cloud-computing  
#gcloud compute scp --zone europe-west3-a setup_dyn_memc.sh root@client-measure-vchb:/home/ubuntu --ssh-key-file ~/.ssh/cloud-computing  
#gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@client-measure-vchb --zone europe-west3-a

# remove if you are using Unix
sudo apt install dos2unix
sudo dos2unix setup_dyn_memc.sh

sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt-get update

sudo bash setup_dyn_mems.sh

cd memcache-perf-dynamics
sudo make

