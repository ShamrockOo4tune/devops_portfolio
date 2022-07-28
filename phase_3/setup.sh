#!/bin/bash
clear
#check if ansible executable is available or install it
if ! [ -x "$(command -v ansible)" ]; 
  then echo -e "No ansible execurable has been foud on PATH \nInsatlling ansible...";
  if ! [[ $(python3 --version | awk '{ print $2 }') =~ 3.(8|9|\d{2}).[0-9] ]];
    then echo "Ansible requires python version >= 3.8";
    exit 1;
  fi
  if ! [ -x "$(command -v pip)" ];
    then echo "missing pip";
    exit 1;
  fi
  python3 -m pip install --user ansible
fi
ansible --version