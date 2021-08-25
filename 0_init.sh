
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