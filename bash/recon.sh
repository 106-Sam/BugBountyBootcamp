#!/bin/bash


DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
PATH_TO_DIRSEARCH=~/dirsearch


TODAY=$(date)
echo "This scan was created on $TODAY"

#Directory Creation
echo "Creating directory $DIRECTORY"
mkdir -p $DIRECTORY

if [ "$2" == "nmap-only" ]
then
	nmap -sC -sV $DOMAIN > $DIRECTORY/nmap
	echo "Saved the Nmap results: $DIRECTORY/nmap"

elif [ "$2" == "dirsearch-only" ]
then
	source $PATH_TO_DIRSEARCH/venv/bin/activate
	python3 $PATH_TO_DIRSEARCH/dirsearch.py -u $DOMAIN -e php -o $DIRECTORY/dirsearch
	echo "Saved the Dirsearch results: $DIRECTORY/dirsearch"
	deactivate

else
	
	#Nmap Scan on the directory
	nmap -sC -sV $DOMAIN > $DIRECTORY/nmap
	echo "Saved the Nmap results: $DIRECTORY/nmap"

	#Dirsearch on the domain
	source $PATH_TO_DIRSEARCH/venv/bin/activate
	python3 $PATH_TO_DIRSEARCH/dirsearch.py -u $DOMAIN -e php -o $DIRECTORY/dirsearch
	echo "Saved the Dirsearch results: $DIRECTORY/dirsearch"
	deactivate
fi

