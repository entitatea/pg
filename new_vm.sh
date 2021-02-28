#!/bin/bash
GROUP=$1
SIZE="Standard_A1_v2"
IMAGE="procomputers:centos-7:centos-7:latest"
host $1.azurecr.io
if [ $? -eq 0 ]
then
  echo "Failure: pick another name!" >&2
  exit 1
else
  echo "Success: Proceeding!"
fi
az group create -l northeurope -n $GROUP
az acr create -n $GROUP -g $GROUP --sku Basic
az vm create -g $GROUP -n $1 --size $SIZE --image $IMAGE --ssh-key-value ~/.ssh/id_rsa.pub --admin-username radu
HOST=`az vm show -d -g $GROUP -n $1 --query publicIps -o tsv`
echo "sleeping 10 seconds"
sleep 10
ssh -oStrictHostKeyChecking=no radu@$HOST "curl https://raw.githubusercontent.com/entitatea/pg/master/install.sh| sudo sh"
ssh -oStrictHostKeyChecking=no radu@$HOST
