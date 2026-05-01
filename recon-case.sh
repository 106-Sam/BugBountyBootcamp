#!/bin/bash


DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
PATH_TO_DIRSEARCH=~/dirsearch


TODAY=$(date)
echo "This scan was created on $TODAY"

#Directory Creation
echo "Creating directory $DIRECTORY"
mkdir -p $DIRECTORY

case $2 in
	nmap-only)
		nmap -sC -sV $DOMAIN > $DIRECTORY/nmap
		echo "saved the Nmap results: $DIRECTORY/nmap."
		;;
	dirsearch-only)
		source $PATH_TO_DIRSEARCH/venv/bin/activate
		python3 $PATH_TO_DIRSEARCH/dirsearch.py -u $DOMAIN -e php -o $DIRECTORY/dirsearch
	        echo "Saved the Dirsearch results: $DIRECTORY/dirsearch."
        	deactivate
		;;
	crt.sh-only)
		curl "https://crt.sh/?q=$DOMAIN&output=json" -o $DIRECTORY/crt
		echo "Saved the cert parsing results: $DIRECTORY/crt."		
		;;
	*)
		 #Nmap Scan on the directory
	        nmap -sC -sV $DOMAIN > $DIRECTORY/nmap
        	echo "Saved the Nmap results: $DIRECTORY/nmap"

	        #Dirsearch on the domain
        	source $PATH_TO_DIRSEARCH/venv/bin/activate
	        python3 $PATH_TO_DIRSEARCH/dirsearch.py -u $DOMAIN -e php -o $DIRECTORY/dirsearch
        	echo "Saved the Dirsearch results: $DIRECTORY/dirsearch"
	        deactivate
		
		#cert 
		curl "https://crt.sh/?=$DOMAIN&output=json" -o $DIRECTORY/crt
		echo "Saved the cert parsing results: $DIRECTORY/crt."
		;;
esac	
