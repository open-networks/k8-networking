#! /bin/bash

source 0_init.sh
printf "\n========================\n"
printf "Let's explore those Pods"
printf "\n========================\n"
printf "\nshow the pods network interfaces and address. note the link index of eth0 this tells us to which veth of the bridge it is connected\n"
read -p 'kubectl exec -it $POD1 -- ip address show'
kubectl exec -it $POD1 -- ip address show
LINK_INDEX=$(kubectl exec -it $POD1 -- ip -j address show | jq '.[]|select(.ifname == "eth0")|.link_index')

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
read -p 'kubectl exec $POD1 -- ping -c 1 $POD2_IP'
kubectl exec $POD1 -- ping -c 1 $POD2_IP
kubectl exec $POD1 -- ping -c 1 $POD3_IP

printf "\nshow pods arp cache with more entries. Recognize that the pods running on other machines are missing\n"
read -p 'kubectl exec -it $POD1 -- arp -a'
kubectl exec $POD1 -- arp -a

printf "\nThe interface index for connected veth of the bridge is $LINK_INDEX.\n"
read -p "Use this in the terminal where you ran lab_1_host.sh and follow instruction there, before you hit enter."

kubectl exec $POD1 -- curl $POD2_IP
