#!/bin/bash
clear
#check if ansible executable is available or install it
if ! [ -x "$(command -v ansible)" ]; 
  then echo -e "No ansible execurable has been foud on PATH \nInsatlling ansible...";
  case $(cat /etc/os-release | awk -FNAME= 'NR == 1 {print $2}') in
    "Ubuntu") apt update;
              apt install software-properties-common;
              add-apt-repository --yes --update ppa:ansible/ansible;
              apt install ansible ;;
    *)        echo 'Please refer to official installation guideline: https://docs.ansible.com/ansible/latest/installation_guide/index.html' ;
              exit 1 ;;
  esac
fi
ansible --version