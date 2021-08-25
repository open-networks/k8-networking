#! /bin/bash

source 0_init.sh
printf "\n========================\n"
printf "Let's explore those Pods"
printf "\n========================\n"
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
kubectl exec $POD1 -- ping -c 3 $POD2_IP
kubectl exec $POD1 -- ping -c 3 $POD3_IP

printf "\nshow pods arp cache with more entries. Recognize that the pods running on other machines are missing\n"
read -p 'kubectl exec -it $POD1 -- arp -a'
kubectl exec $POD1 -- arp -a


printf "\n=====================\n"
printf "lets explore the host"
printf "\n=====================\n"

printf "\nshow status and config of the kubelet service\n"
read -p "kubectl exec -it multitool-privileged -- chroot /host systemctl status kubelet.service"
kubectl exec -it multitool-privileged -- chroot /host systemctl status kubelet.service

printf "\nshow the host interfaces and ip addresses\n"
read -p "kubectl exec multitool-privileged -- chroot /host ip address show"
kubectl exec multitool-privileged -- chroot /host ip address show

printf "\nshow hosts route\n"
read -p "kubectl exec multitool-privileged -- chroot /host route"
kubectl exec multitool-privileged -- chroot /host route

printf "\nshow the hosts linux bridges\n"
read -p "kubectl exec multitool-privileged -- chroot /host brctl show"
kubectl exec multitool-privileged -- chroot /host brctl show

printf "\nexplore the kubernetes bridge\n"
read -p "enter brdige device name:" BRIDGE
read -p 'kubectl exec multitool-privileged -- chroot /host brctl showmacs $BRIDGE'
kubectl exec multitool-privileged -- chroot /host brctl showmacs $BRIDGE


printf "\n look at the cni configs\n"
read -p 'kubectl exec multitool-privileged -- chroot /host ls /etc/cni/net.d/ -la'
kubectl exec multitool-privileged -- chroot /host ls /etc/cni/net.d/ -la
read -p 'kubectl exec multitool-privileged -- chroot /host cat  /etc/cni/net.d/*'
kubectl exec multitool-privileged -- chroot /host cat $(kubectl exec multitool-privileged -- chroot /host find /etc/cni/net.d/)




# shows dns config
kubectl exec -it multitool-privileged -- chroot /host cat var/lib/kubelet/config.yaml

#test service
read -p "kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'"
kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'

read -p "kubectl expose deployment multitool --port 80"
kubectl expose deployment multitool --port 80

read -p "kubectl describe service multitool"
kubectl describe service multitool

read -p "kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'"
kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'