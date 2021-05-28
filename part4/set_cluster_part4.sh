#!/bin/bash

PROJECT="project-cca-313617"
id="moeschp"
# pro. id = project-cca-313617

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

      echo "start gcloud (y/n) [default: no]"
      read ans 

      if [[ "$ans" == "y" ]]; then
         echo "gcloud init"
         gcloud init --skip-diagnostics
      fi
      
      echo "create bucket? (y/n) [default: no]"
      read ans 
      
      if [[ "$ans" == "y" ]]; then
         echo "gsutil mb gs://$KOPS_STATE_STORE"
         sudo gsutil mb gs://$KOPS_STATE_STORE
      fi

      echo "CREATING CLUSTER"
      echo "kops create -f part4.yaml"
      kops create -f part4.yaml --state $PROJECT-$id
      echo "kops update cluster part4.k8s.local --yes --admin"
      kops update cluster --name part4.k8s.local --yes --admin --state $PROJECT-$id
      echo "kops validate cluster --wait 10m"
      kops validate cluster --wait 10m  --state $PROJECT-id
      echo "cluster ready"
   }

   
   auth() {
       echo "gcloud auth application-default login"
       gcloud auth application-default login
   }


   install_() {
   
      echo "sending execution script to server"
      #gcloud compute scp --zone europe-west3-a $2 root@$1:/home/ubuntu --ssh-key-file ~/.ssh/cloud-computing  
      echo "connection to server..."
      echo "run the script, execute ls to find it"
      #gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@$1 --zone europe-west3-a 'echo hello'

      echo "left vm"
         
   }
   
   remove_cluster() {
      echo "kops delete cluster part4.k8s.local --yes --state $PROJECT-$id"
      kops delete cluster part4.k8s.local --yes --state $PROJECT-$id
   }


echo "cluster already set? (y/n) [default: no]"
read ans 

if [[ "$ans" != "y" ]]; then
   build_cluster
fi

printf "\n End here [0] \n Install memcache on memcache-server [1] \n Install mcperf on agent-server [2] \n Install mcperf on measure-server [3] \n Install everything [4] \n Delete Cluster[5] \n Authentify[6] \n"

read ans
if [[ "$ans" == "0" ]]; then
    exit
fi

if [[ "$ans" == "5" ]]; then
    remove_cluster
    exit
fi

if [[ "$ans" == "6" ]]; then
    auth
    exit
fi
 
echo "fetching cluster data..."
printf "\n"

t=$(kubectl get nodes -o wide)

# in list form
tl=($t)

#sudo apt install dos2unix
dos2unix setup_dyn_memc.sh
dos2unix setup_memc.sh

# memcache
if [[ "$ans" == "1" || "$ans" == "4" ]]; then
echo "installing memcache..."
name="${tl[46]}"
ip="${tl[52]}"
echo $name
echo $ip
ssh -i ~/.ssh/cloud-computing ubuntu@$ip 'echo hello'
# gcloud compute ssh --ssh-key-file ~/.ssh/cloud-computing ubuntu@$name --zone europe-west3-a
   #install_ "$name" "setup_memc.sh"
fi

#agent
if [[ "$ans" == "2" || "$ans" == "4" ]]; then
echo "installing parsec on agent..."
name="${tl[10]}"
   install_ "$name" "setup_dyn_memc.sh"
fi

#measure
if [[ "$ans" == "3" || "$ans" == "4" ]]; then
echo "installing parsec on measure..."
name="${tl[22]}"
   install_ "$name" "setup_dyn_memc.sh"
fi




