#!/bin/bash

# 1)First input : choose interference 
# 2)wait until interference starts (htop on parsec VM), then press enter 
# 3)Second Input : choose workload
# 4)Wait until workload finishes (or let the terminal wait for 20s - 2 min depending on workload)
# run as : bash runit.sh

echo ibench-cpu ibench-l1d ibench-l1i ibench-l2 ibench-llc ibench-membw none

read inter 

if [[ "$inter" != "none" ]]; then
    kubectl create -f interference/"$inter".yaml
fi

echo press key... # sleep 20
read ok

echo blacksholes dedup fft canneal ferret freqmine all none

read benchmark
count=1; # number of runs

#if [[ "$benchmark" == "none" || "$benchmark" == "all" ]]; then
#    for i in $(seq $count); do
#        kubectl create -f parsec-benchmarks/part2a/parsec-canneal.yaml
#        echo run number $i, press key to go on
#        read ok
#        ans=$(kubectl logs $(kubectl get pods --selector=job-name=parsec-canneal --output=jsonpath='{.items[*].metadata.name}'))
#        echo "${ans}" | grep user
#        #echo "${ans}"
#        kubectl delete jobs --all
#    done
#fi

if [[ "$benchmark" == "fft" || "$benchmark" == "all" ]]; then
    for i in $(seq $count); do
        echo running fft
        kubectl create -f parsec-benchmarks/part2a/parsec-fft.yaml
        echo run number $i #, press key to go on
        echo sleeping...
        sleep 3m # 2 minutes was not enough sometimes
        #read ok # sleep ...
        ans=$(kubectl logs $(kubectl get pods --selector=job-name=parsec-splash2x-fft --output=jsonpath='{.items[*].metadata.name}'))
        echo "${ans}" | grep user
        #echo "${ans}"
        kubectl delete jobs --all
    done
fi

if [[ "$benchmark" == "freqmine" || "$benchmark" == "all" ]]; then
    for i in $(seq $count); do
        echo running freqmine
        kubectl create -f parsec-benchmarks/part2a/parsec-freqmine.yaml
        echo run number $i #, press key to go on
        echo sleeping...
        sleep 3m # 2 minutes was not enough sometimes
        #read ok
        ans=$(kubectl logs $(kubectl get pods --selector=job-name=parsec-freqmine --output=jsonpath='{.items[*].metadata.name}'))
        echo "${ans}" | grep user
        #echo "${ans}"
        kubectl delete jobs --all
    done
fi

if [[ "$benchmark" == "ferret" || "$benchmark" == "all" ]]; then
    for i in $(seq $count); do
        echo running ferret
        kubectl create -f parsec-benchmarks/part2a/parsec-ferret.yaml
        echo run number $i #, press key to go on
        sleep 30s
        #read ok
        ans=$(kubectl logs $(kubectl get pods --selector=job-name=parsec-ferret --output=jsonpath='{.items[*].metadata.name}'))
        echo "${ans}" | grep user
        #echo "${ans}"
        kubectl delete jobs --all
    done
fi

if [[ "$benchmark" == "dedup" || "$benchmark" == "all" ]]; then
    for i in $(seq $count); do
        echo running dedup
        kubectl create -f parsec-benchmarks/part2a/parsec-dedup.yaml
        echo run number $i #, press key to go on
        echo sleeping...
        sleep 3m # 2 minutes was not enough sometimes
        ans=$(kubectl logs $(kubectl get pods --selector=job-name=parsec-dedup --output=jsonpath='{.items[*].metadata.name}'))
        #echo "${ans}" | grep user
        echo "${ans}"
        kubectl delete jobs --all
    done
fi


if [[ "$benchmark" == "canneal" || "$benchmark" == "all" ]]; then
    for i in $(seq $count); do
        echo running canneal
        kubectl create -f parsec-benchmarks/part2a/parsec-canneal.yaml
        echo run number $i #, press key to go on
        sleep 30s
        #read ok
        ans=$(kubectl logs $(kubectl get pods --selector=job-name=parsec-canneal --output=jsonpath='{.items[*].metadata.name}'))
        echo "${ans}" | grep user
        #echo "${ans}"
        kubectl delete jobs --all
    done
fi

if [[ "$benchmark" == "blacksholes" || "$benchmark" == "all" ]]; then
    for i in $(seq $count); do
        echo running blacksholes
        kubectl create -f parsec-benchmarks/part2a/parsec-blacksholes.yaml
        echo run number $i #, press key to go on
        echo sleeping...
        sleep 3m # 2 minutes was not enough sometimes
        #read ok
        ans=$(kubectl logs $(kubectl get pods --selector=job-name=parsec-blacksholes --output=jsonpath='{.items[*].metadata.name}'))
        echo "${ans}" | grep user
        #echo "${ans}"
        kubectl delete jobs --all
    done
fi

kubectl delete pods --all