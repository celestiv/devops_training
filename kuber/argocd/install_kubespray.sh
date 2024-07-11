#!/bin/bash

# Предварительно нужно прокинуть ssh ключи на машину или машины, которые мы будет использовать для установки
# В данном случае мы ставим кластер только на одну машину, которая будет и админом и рабочей машиной
# поэтому используем айпи машины
MY_IP=$(ip addr show enp0s3 | grep "inet\b" | awk '{print $2}' \ | cut -d/ -f1)
echo $MY_IP

echo $USER

ssh-keygen

ssh-copy-id $USER@$MY_IP


sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf update -y

sudo systemctl disable firewalld --now

sudo dnf install -y git ansible python3.11 python3.11-pip

git clone https://github.com/kubernetes-sigs/kubespray
cd kubespray

python3.11 -m pip install -r requirements.txt

CLUSTER_FOLDER='mycluster'
cp -fpr inventory/sample inventory/$CLUSTER_FOLDER


python3.11 -m pip install ruamel.yaml

CONFIG_FILE=inventory/$CLUSTER_FOLDER/hosts.yaml python3.11 contrib/inventory_builder/inventory.py ${MY_IP[@]}

# для проверки настройки файла конфигурации. Здесь пропишутся наши мастер и worker ноды, их список и адреса
# cat inventory/$CLUSTER_FOLDER/hosts.yaml

ansible-playbook -u $USER -i inventory/$CLUSTER_FOLDER/hosts.yaml cluster.yml -b --diff --ask-become-pass --ask-pass

sudo cp -r /root/.kube $HOME
sudo chown -R $USER $HOME/.kube
kubectl get po -n kube-system

kubectl create ns argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.5.8/manifests/install.yaml

# kubectl get po -n argocd

nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 --address=$MY_IP &
echo $MY_IP:8080
