#!/bin/bash


DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
PATH_TO_DIRSEARCH=~/dirsearch


TODAY=$(date)

#Directory Creation
echo "Creating directory $DIRECTORY"
mkdir -p $DIRECTORY
echo -e "This scan was created on $TODAY\n"> $DIRECTORY/results

nmap_scan(){
	nmap $DOMAIN > $DIRECTORY/nmap
	echo -e "Results for Nmap:\n" >> $DIRECTORY/results
	grep -E "^\S+\s+\S+\s+\S*$" $DIRECTORY/nmap >> $DIRECTORY/results
}
dirsearch_scan(){
	source $PATH_TO_DIRSEARCH/venv/bin/activate
	python3 $PATH_TO_DIRSEARCH/dirsearch.py -u $DOMAIN -e php -o $DIRECTORY/dirsearch
        echo "Saved the Dirsearch results: $DIRECTORY/dirsearch."
	echo -e "Results for Dirsearch:\n" >> $DIRECTORY/results
	cat $DIRECTORY/dirsearch >> $DIRECTORY/results
       	deactivate
}
crt_scan(){
	curl -o $DIRECTORY/crt "https://crt.sh/?q=$DOMAIN&output=json"
	echo -e "\nResults for cert parsing:\n" >> $DIRECTORY/results
	echo "Saved the cert parsing results: $DIRECTORY/crt."
	jq -r ".[] | .name_value" $DIRECTORY/crt >> $DIRECTORY/results
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
