#!/bin/bash
#tf_ver=$(terraform -v | awk 'NR == 1 {print substr($2,2)}')

echo 'Initializing setup variables...'
export $(grep -v '^#' ./phase_1/setup.env | xargs)
echo -e "\nFollowing variables are now set:\n$(grep -v '^#' ./phase_1/setup.env)\n"

if ! [ -x "$(command -v terraform)" ]; 
  then echo -e "No terraform execurable has been foud on PATH \nInsatlling terraform...";
  case $(uname -m) in
    i386 | i686)   ARCHITECTURE="386" ;;
    x86_64)        ARCHITECTURE="amd64" ;;
    arm)           dpkg --print ARCHITECTURE | grep -q "arm64" && ARCHITECTURE="arm64" || ARCHITECTURE="arm" ;;
    *)             echo "Unable to determine system ARCHITECTURE."; exit 1 ;;
  esac
  wget -nc -q https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_${ARCHITECTURE}.zip
  unzip -o ./terraform_${TF_VER}_linux_${ARCHITECTURE}.zip && rm terraform_${TF_VER}_linux_${ARCHITECTURE}.zip
  mv ./terraform /usr/local/bin/terraform
  echo -e "\nInstallation complete:"
  terraform -v
fi
