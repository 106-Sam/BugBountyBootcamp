#!/bin/bash


DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
PATH_TO_DIRSEARCH=~/dirsearch


TODAY=$(date)
echo "This scan was created on $TODAY"

#Directory Creation
echo "Creating directory $DIRECTORY"
mkdir -p $DIRECTORY

nmap_scan(){
	nmap -sC -sV $DOMAIN > $DIRECTORY/nmap
	echo "saved the Nmap results: $DIRECTORY/nmap."
}
dirsearch_scan(){
	source $PATH_TO_DIRSEARCH/venv/bin/activate
	python3 $PATH_TO_DIRSEARCH/dirsearch.py -u $DOMAIN -e php -o $DIRECTORY/dirsearch
        echo "Saved the Dirsearch results: $DIRECTORY/dirsearch."
       	deactivate
}
crt_scan(){
	curl "https://crt.sh/?q=$DOMAIN&output=json" -o $DIRECTORY/crt
	echo "Saved the cert parsing results: $DIRECTORY/crt."		
}

case $2 in
	nmap-only)
		nmap_scan
		;;
	dirsearch-only)
		dirsearch_scan
		;;
	crt-only)
		crt_scan
		;;
	*)
		nmap_scan
		dirsearch_scan
		crt_scan
esac
