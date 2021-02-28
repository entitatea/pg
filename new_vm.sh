#!/bin/bash
# Azure built stuff
# entitatea[at]gmail[dot]com
# set -e
usage ()
{
    echo "Usage: $0 [OPTIONS]"
    echo " -g <Resource_Group_Name> -u <username> -v <vm_name>"
    echo " E.g.:" $0 "-g AzureRG -u alex -v myVM"
    echo ""
}
while getopts 'h:g:u:v:' OPTION
do
    case $OPTION in
        h)
            usage
            exit 0
            ;;
        g)
            export GROUP=$OPTARG
            ;;
        u)
            export USER=$OPTARG
            ;;
        v)
            export VM=$OPTARG
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

#Test vars
if [ -z "$GROUP" ] || [ -z "$USER" ] || [ -z "$VM" ]; then usage; exit 1; fi

SIZE="Standard_A1_v2"
IMAGE="procomputers:centos-7:centos-7:latest"
SSH_KEY="~/.ssh/id_rsa.pub"
host $GROUP.azurecr.io
if [ $? -eq 0 ]
then
  echo "Failure: pick another group name!" >&2
  exit 1
else
  echo "Success: Proceeding!"
fi
az group create -l northeurope -n $GROUP
az acr create -n $GROUP -g $GROUP --sku Basic
az vm create -g $GROUP -n $VM --size $SIZE --image $IMAGE --ssh-key-value $SSH_KEY --admin-username $USER
HOSTIP=`az vm show -d -g $GROUP -n $VM --query publicIps -o tsv`
echo "sleeping 10 seconds"
sleep 10
ssh -oStrictHostKeyChecking=no $USER@$HOSTIP "curl https://raw.githubusercontent.com/entitatea/pg/master/install.sh| sudo sh"
ssh -oStrictHostKeyChecking=no $USER@$HOSTIP
