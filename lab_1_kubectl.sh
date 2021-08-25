#! /bin/bash

source 0_init.sh

printf "\nLook at pods\n"
read -p "kubectl get pods -o wide"
kubectl get pods -o wide


printf "\nStore get pod names and ip in variables. POD1, POD1_IP, ...\n"
read -p 'POD1=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].metadata.name}")'
POD1=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].metadata.name}")
POD2=$(kubectl get pod -l app=multitool -o jsonpath="{.items[1].metadata.name}")
POD3=$(kubectl get pod -l app=multitool -o jsonpath="{.items[2].metadata.name}")
POD1_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[0].mstatus.podIP}")
POD2_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[1].status.podIP}")
POD3_IP=$(kubectl get pod -l app=multitool -o jsonpath="{.items[2].status.podIP}")

read -p "Let's explore those Pods"

printf "\nshow the pods network interfaces and address\n"
read -p 'kubectl exec -it $POD1 -- ip address show'
kubectl exec -it $POD1 -- ip address show

printf "\nshow the pods routes\n"
read -p 'kubectl exec -it $POD1 -- route'
kubectl exec $POD1 -- route

printf "\nshow the pods dns\n"
read -p 'kubectl exec -it $POD1 -- cat /etc/resolv.conf'
kubectl exec $POD1 -- cat /etc/resolv.conf

printf "\nshow the pods arp cache with only one entry\n"
read -p 'kubectl exec -it $POD1 -- arp -a'
kubectl exec $POD1 -- arp -a

printf "\nping pod 2 and pod 3\n"
read -p 'kubectl exec $POD1 -- ping -c 4 $POD2_IP'
kubectl exec $POD1 -- ping -c 4 $POD2_IP
kubectl exec $POD1 -- ping -c 4 $POD3_IP

printf "\nshow pods arp cache with more entries. Recognize that the pods running on other machines are missing\n"
read -p 'kubectl exec -it $POD1 -- arp -a'
kubectl exec $POD1 -- arp -a




