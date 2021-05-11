#!/bin/bash

sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo apt-get update

sudo apt-get update
sudo apt-get install libevent-dev libzmq3-dev git make g++ --yes
sudo apt-get build-dep memcached --yes
git clone https://github.com/eth-easl/memcache-perf-dynamic.git
cd memcache-perf-dynamic
sudo make

echo "process complete, write exit to leave vm"

#fix for the sources not listed error of "sudo apt-get build-dep memcached --yes"
#sudo cp /etc/apt/sources.list /etc/apt/sources.list~
#sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
#sudo apt-get update
