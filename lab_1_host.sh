#! /bin/bash

source 0_init.sh

printf "\n=====================\n"
printf "lets explore the host"
printf "\n=====================\n"

printf "\nshow status and config of the kubelet service\n"
read -p "kubectl exec -it multitool-privileged -- chroot /host systemctl status kubelet.service"
kubectl exec -it multitool-privileged -- chroot /host systemctl status kubelet.service -n 0
read -p "kubectl exec -it multitool-privileged -- chroot /host cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
kubectl exec -it multitool-privileged -- chroot /host cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

printf "\n show installed cni plugin binaries\n"
read -p 'kubectl exec multitool-privileged -- chroot /host ls -la /opt/cni/bin/'
kubectl exec multitool-privileged -- chroot /host ls -la /opt/cni/bin/

printf "\nlook at the cni configs\n"
read -p 'kubectl exec multitool-privileged -- chroot /host ls /etc/cni/net.d/ -la'
kubectl exec multitool-privileged -- chroot /host ls /etc/cni/net.d/ -la
read -p 'kubectl exec multitool-privileged -- chroot /host cat  /etc/cni/net.d/*'
kubectl exec multitool-privileged -- chroot /host cat $(kubectl exec multitool-privileged -- chroot /host find /etc/cni/net.d/)



printf "\nshow the host interfaces and ip addresses\n"
read -p "kubectl exec multitool-privileged -- chroot /host ip address show"
kubectl exec multitool-privileged -- ip address show

printf "\nPlease enter the the interface index from before \n"
read -p "link index:" LINK_INDEX
PODS_BRIDGE_INTERFACE=$(kubectl exec multitool-privileged -- chroot /host ip -j address show | jq -r --argjson L "$LINK_INDEX" '.[] | select(.ifindex == $L)|.ifname')
printf "\nThe bridge interface for your pod is $PODS_BRIDGE_INTERFACE.\n"

printf "\nshow hosts route\n"
read -p "kubectl exec multitool-privileged --  route"
kubectl exec multitool-privileged -- route

printf "\nshow the hosts linux bridges\n"
read -p "kubectl exec multitool-privileged -- brctl show"
kubectl exec multitool-privileged -- brctl show

printf "\nexplore the kubernetes bridge\n"
read -p "enter brdige device name:" BRIDGE
read -p 'kubectl exec multitool-privileged  brctl showmacs $BRIDGE'
kubectl exec multitool-privileged -- brctl showmacs $BRIDGE

kubectl exec -it multitool-privileged -- tcpdump -i $PODS_BRIDGE_INTERFACE