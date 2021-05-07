#!/bin/bash

sudo apt update
sudo apt install -y memcached libmemcached-tools docker python3-pip
systemctl status memcached
#I have never used the vim CommandLine to alter a file in vim so there is no automation for altering the memcached.config
sudo pip3 install docker psutil



