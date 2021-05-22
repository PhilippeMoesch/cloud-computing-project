#!/bin/bash

kubectl create -f parsec-dedup.yaml
kubectl create -f parsec-canneal.yaml
kubectl create -f parsec-blackscholes.yaml
kubectl create -f parsec-freqmine.yaml
kubectl create -f parsec-ferret.yaml
kubectl wait --for=condition=complete --timeout=300s job/parsec-dedup
kubectl get jobs
kubectl create -f parsec-fft.yaml
kubectl wait --for=condition=complete --timeout=300s job/parsec-splash2x-fft
echo "done"
