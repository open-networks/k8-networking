#! /bin/bash

printf "\ncreate namespace\n" 
read -p "kubectl create namespace network-testing"
kubectl create namespace network-testing

printf "\nchange to namespace\n" 
read -p "kubectl config set-context --current --namespace=network-testing"
kubectl config set-context --current --namespace=network-testing

printf "\nlaunch multiple multitool pods\n"
read -p "kubectl apply -f https://raw.githubusercontent.com/open-networks/k8-networking/main/deployment-multitool.yaml"
kubectl apply -f https://raw.githubusercontent.com/open-networks/k8-networking/main/deployment-multitool.yaml

printf "\nlaunch privileged pod to access host\n"
read -p "kubectl apply -f https://raw.githubusercontent.com/open-networks/k8-networking/main/pod-privileged.yaml"
kubectl apply -f https://raw.githubusercontent.com/open-networks/k8-networking/main/pod-privileged.yaml

printf "\nwait until all pods are ready\n"
read -p "kubectl wait --for condition=Ready pod --all"
kubectl wait --for condition=Ready pod --all


printf "\nLook at pods\n"
read -p "kubectl get pods -o wide"
kubectl get pods -o wide


printf "\nStore pod names and ip in variables. POD1, POD1_IP, ...\n"
read -p 'POD1=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].metadata.name}")'
POD1=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].metadata.name}")
POD2=$(kubectl get pod -l app=multitool -o jsonpath="{.items[1].metadata.name}")
POD3=$(kubectl get pod -l app=multitool -o jsonpath="{.items[2].metadata.name}")
POD1_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].status.podIP}")
POD2_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[1].status.podIP}")
POD3_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[2].status.podIP}")


