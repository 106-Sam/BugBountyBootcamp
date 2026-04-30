#!/bin/bash


DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
PATH_TO_DIRSEARCH=~/dirsearch

#Directory Creation
echo "Creating directory $DIRECTORY"
mkdir $DIRECTORY

#Nmap Scan on the directory
nmap -sC -sV $DOMAIN > $DIRECTORY/nmap
echo "Saved the Nmap results:$DIRECTORY/nmap"

#Dirsearch on the domain

source $PATH_TO_DIRSEARCH/venv/bin/activate
python3 $PATH_TO_DIRSEARCH/dirsearch.py -u $DOMAIN -e php -o $DIRECTORY/dirsearch 
deactivate
