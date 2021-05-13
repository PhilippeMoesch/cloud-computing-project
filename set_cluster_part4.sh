#!/bin/bash

PROJECT=$(gcloud config get-value project)
id="moeschp"
#echo $PROJECT
   build_cluster() {
      echo "enter ID [default: moeschp]"
      read ans
      
      export KOPS_STATE_STORE=$PROJECT-$id
      export KOPS_FEATURE_FLAGS=AlphaAllowGCE
      
      echo "Empty bucket ? (y/n) [default: no]"
      read ans 

      if [[ "$ans" == "y" ]]; then
         echo "gsutil -m rm -r gs://$KOPS_STATE_STORE"
         gsutil -m rm -r gs://$KOPS_STATE_STORE
      fi

      echo "start gcloud & create bucket? (y/n) [default: yes]"
      read ans 

      if [[ "$ans" != "n" ]]; then
         echo "gcloud init"
         gcloud init
         echo "gsutil mb gs://$KOPS_STATE_STORE"
         gsutil mb gs://$KOPS_STATE_STORE
      fi

      #gcloud auth application-default login

      echo "CREATING CLUSTER"
      echo "kops create -f part4.yaml"
      sudo kops create -f part4.yaml #--state $PROJECT-$id
      echo "kops update cluster --name part4.k8s.local --yes --admin"
      kops update cluster --name part4.k8s.local --yes --admin #--state $PROJECT-$id
      echo "kops validate cluster --wait 10m"
      kops validate cluster --wait 10m # --state $PROJECT-id
      echo "cluster ready"
   }


   parse_data() {
      echo "parsing cluster data..."
      printf "\n"

      #sudo kubectl get nodes -o wide
      t=$(sudo kubectl get nodes -o wide)
      
      if [[ "$1" == "ip_memcache" ]]; then
         ips=$(echo "$t" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
         ips=($ips)
         echo "${ips[6]}"
      elif [[ "$1" == "ip_agent" ]]; then
         ips=$(echo "$t" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
         ips=($ips)
         echo "${ips[0]}"
      else
         # specific VM name
         name=($(echo "$t" | grep '$1'))
         if [[ "$1" != "measure" ]]; then
            name=${name[0]}
         fi
         echo "$name"
      fi
   }


   install_() {
   
      echo "sending execution script to server"
      gcloud compute scp --zone europe-west3-a $2 root@$1:/home/ubuntu --ssh-key-file ~/.ssh/cloud-computing  
      echo "connection to server..."
      echo "run the script, execute ls to find it"
      gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@$1 --zone europe-west3-a
      echo "left vm"
         
   }
   
   remove_cluster() {
      echo "kops delete cluster part4.k8s.local --yes --state $PROJECT-$id"
      kops delete cluster part4.k8s.local --yes --state $PROJECT-$id
      exit  
   }


echo "cluster already set? (y/n) [default: no]"
read ans 

if [[ "$ans" != "y" ]]; then
   build_cluster
fi

printf "\n End here [0] \n Install memcache on memcache-server [1] \n Install mcperf on agent-server [2] \n Install mcperf on measure-server [3] \n Install everything [4] \n Delete Cluster[5] \n"

read ans
if [[ "$ans" == "0" ]]; then
    exit
fi

if [[ "$ans" == "5" ]]; then
    remove_cluster
fi
 
sudo apt install dos2unix
sudo dos2unix setup_dyn_memc.sh
sudo dos2unix setup_memc.sh

# memcache
echo "installing memcache..."
name="$(parse_data "memcache")"
if [[ "$ans" == "1" || "$ans" == "4" ]]; then
   install_ "$name" "setup_memc.sh"
fi

#agent
echo "installing parsec on agent..."
name="$(parse_data "agent")"
if [[ "$ans" == "2" || "$ans" == "4" ]]; then
   install_ "$name" "setup_dyn_memc.sh"
fi

#measure
echo "installing parsec on measure..."
name="$(parse_data "measure")"
if [[ "$ans" == "3" || "$ans" == "4" ]]; then
   install_ "$name" "setup_dyn_memc.sh"
fi




