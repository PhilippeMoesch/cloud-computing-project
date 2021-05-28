#!/bin/bash

#if [[ -n $SSH_CONNECTION ]] ; then
   echo "Memcache-Server : install memcache/docker/pyton3-pip"
   sudo apt update
   sudo apt install -y memcached libmemcached-tools docker python3-pip
   echo "Done, now modyfing configuration file"
   sudo sed -i "s/^-m.*/-m ${1024}/"  /etc/memcached.conf
   echo "enter internal ip"
   read $internal_memcache
   sudo sed -i "s/^-l.*/-l ${internal_memcache}/"  /etc/memcached.conf
   #sudo sed -i "s/^-t.*/-t ${num_threads}/"  /etc/memcached.conf
   sudo systemctl restart memcached
   sudo systemctl status memcached

   sudo pip3 install docker psutil
   echo "memcached running, write exit to leave VM"

#fi
