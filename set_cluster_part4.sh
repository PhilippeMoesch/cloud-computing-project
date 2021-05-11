#!/bin/bash
# if you need more echos : set -x #echo on 

# specifiy number of memcached threads here :
# num_threads = 1 

# if error : x509: certificate signed by unknown authority]
# exectute : export no_proxy=$no_proxy,*.docker.internal

#enter yes to jump to the next step directly


   build_cluster() {
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
         sudo gsutil -m rm -r $KOPS_STATE_STORE
         echo "gsutil mb $KOPS_STATE_STORE"
         sudo gsutil mb $KOPS_STATE_STORE
      fi

      echo "CREATING CLUSTER"
      PROJECT='glcoud config get-value project'
      echo "kops create -f part4.yaml"
      sudo kops create -f part4.yaml --state cca-eth-2021-group-20-$id
      echo "kops update cluster --name part4.k8s.local --yes --admin"
      sudo kops update cluster --name part4.k8s.local --yes --admin --state cca-eth-2021-group-20-$id
      echo "kops validate cluster --wait 10m"
      sudo kops validate cluster --wait 10m --state cca-eth-2021-group-20-$id
      echo "cluster ready"
   }


   parse_data() {
      echo "parsing cluster data..."
      printf "\n"

      #sudo kubectl get nodes -o wide
      t=$(sudo kubectl get nodes -o wide)
      
      if [[ "$1" == "ip" ]]; then
         ips=$(echo "$t" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
         ips=($ips)
         echo "${ips[6]}"
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
      sudo kops delete cluster part4.k8s.local --yes --state cca-eth-2021-group-20-moeschp
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




