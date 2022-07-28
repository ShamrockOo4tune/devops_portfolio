#!/bin/bash
clear
echo 'Initializing setup variables...'
export $(grep -v '^#' ./setup.env | xargs)
echo -e "\nFollowing variables are now set:\n$(grep -v '^#' ./setup.env)\n"

#check if compatible terraform executable is available or install it
if ! [ -x "$(command -v terraform)" ]; 
  then echo -e "No terraform execurable has been foud on PATH \nInsatlling terraform...";
  case $(uname -m) in
    i386 | i686)   ARCHITECTURE='386' ;;
    x86_64)        ARCHITECTURE='amd64' ;;
    arm)           dpkg --print ARCHITECTURE | grep -q 'arm64' && ARCHITECTURE='arm64' || ARCHITECTURE='arm' ;;
    *)             echo 'Unable to determine system ARCHITECTURE'; exit 1 ;;
  esac
  wget -nc -q https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_${ARCHITECTURE}.zip
  unzip -o ./terraform_${TF_VER}_linux_${ARCHITECTURE}.zip && rm terraform_${TF_VER}_linux_${ARCHITECTURE}.zip
  mv ./terraform /usr/local/bin/terraform
  echo -e '\nInstallation complete:'
  terraform -v
elif 
  [ $(terraform -v | awk 'NR == 1 {print substr($2,2,1)}') = ${TF_VER:0:1} ];
  then echo 'Detected terraform version should be compatible:'
  terraform -v
else
  echo 'Current version of Terraform on the system is not compatible. Please upgrade it or uninstall:'
  terraform -v
  exit 1
fi

if [[ -v AWS_ACCESS_KEY_ID && -v AWS_SECRET_ACCESS_KEY_ID ]];
  then echo -e '\nUsing AWS credentials from env variables';
elif test -f ~/.aws/credentials;
  then echo -e '\nUsing AWS credentials from credentials file';
else
  echo -e '\nBe ready to provide AWS credentials'
fi

#create remote backend for TF states
terraform -chdir=../infrastructure/infra/remote_state init 
terraform -chdir=../infrastructure/infra/remote_state apply -auto-approve
terraform -chdir=../infrastructure/infra/remote_state output > backend.hcl

sed -i 's|backend "local" {}|backend "s3" {\n    key = "infrastructure/infra/remote_state/terraform.tfstate"\n    encrypt = true\n  }|' ../infrastructure/infra/remote_state/main.tf
terraform -chdir=../infrastructure/infra/remote_state init -migrate-state -backend-config=../../../phase_1/backend.hcl -force-copy

# create key-pair for remote access to nodes
ssh-keygen -q -t rsa -b 4096 -f ./nodes_key -N ""
