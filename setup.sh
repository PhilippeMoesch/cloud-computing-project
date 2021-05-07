#!/bin/bash

apt-get update
apt-get install -y memcached libmemcached-tools docker python3-pip
systemctl status memcached
pip3 install docker psutil