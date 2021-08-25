#! /bin/bash

kubectl create namespace network-testing
kubectl config set-context --current --namespace=network-testing
kubectl apply -f https://raw.githubusercontent.com/open-networks/k8-networking/main/deployment-multitool.yaml
kubectl apply -f https://raw.githubusercontent.com/open-networks/k8-networking/main/pod-privileged.yaml
printf "waiting for pods to come online\n"
kubectl wait --for condition=Ready pod --all
POD1=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].metadata.name}")
POD2=$(kubectl get pod -l app=multitool -o jsonpath="{.items[1].metadata.name}")
POD3=$(kubectl get pod -l app=multitool -o jsonpath="{.items[2].metadata.name}")
POD1_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].status.podIP}")
POD2_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[1].status.podIP}")
POD3_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[2].status.podIP}")
