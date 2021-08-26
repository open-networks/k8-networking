#! /bin/bash

source 0_init.sh
printf "\n========================\n"
printf "Let's explore service"
printf "\n========================\n"


#test service
printf "\n inspect kube-proxy. it is running as a daemon set on each node\n"
kubectl get daemonset kube-proxy -n kube-system
kubectl describe pods kube-proxy -n kube-system

printf "\n verify that there are no entries for the network-testing/multitool project in iptables.\n"
read -p "kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'"
kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'

printf "\ncreate a service\n"
read -p "kubectl expose deployment multitool --port 80"
kubectl expose deployment multitool --port 80

printf "\ninspect the service\n"
read -p "kubectl describe service multitool"
kubectl describe service multitool

printf "\niptables rules have been added.\n"
printf "KUBE-SERVICE entries  show starting rules when the service ip is to be reached and forward it to KUBE-SVC.\n"
printf "KUBE-SVC entries shows the loadbalancing with by forwarding it to KUBE-SEP with the --propability flag.\n"
printf "KUBE-SEP entries add DNAT to the coressponding Pod ip.\n"
read -p "kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'"
kubectl exec multitool-privileged -- chroot /host iptables-save | grep 'network-testing/multitool'


printf "\nshow the dns service\n"
read -p "kubectl get service kube-dns -n kube-system"
kubectl get service kube-dns -n kube-system
read -p "kubectl get deployment coredns -n kube-system"
kubectl get deployment coredns -n kube-system

printf "\nshow the pods dns\n"
read -p 'kubectl exec -it $POD1 -- cat /etc/resolv.conf'
kubectl exec $POD1 -- cat /etc/resolv.conf

# shows dns config
printf "\nshow dns server config\n"
read -p 'kubectl exec -it multitool-privileged -- chroot /host cat var/lib/kubelet/config.yaml'
kubectl exec -it multitool-privileged -- chroot /host cat var/lib/kubelet/config.yaml


printf "apply ingresses for multitool application"

printf '\nexpose service via LoadBalancer\n'
read -p "kubectl expose deployment multitool --port 80 --type=LoadBalancer --name mutitool-external"
kubectl expose deployment multitool --port 80 --type=LoadBalancer --name mutitool-external
read -p "kubectl get service multitool-external"
kubectl get service multitool-external
NODE_PORT=$(kubectl get service multitool-external -o json | jq -r '.spec.ports[].nodePort')
NODE_ADDRESS=$(kubectl get node -o json |jq -r '.items[0].status.addresses[0].address')

printf "\nVerify that service is accessible via node port. External ip can be assigned by the external loadbalancer manually\n"
curl $NODE_ADDRESS:$NODE_PORT

printf 'expose service via Ingress'
read -p 'kubectl apply -f ingress_example.yaml'
kubectl apply -f ingress_example.yaml

curl $NODE_ADDRESS

# istio example microservice app.
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml 
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/istio-manifests.yaml
