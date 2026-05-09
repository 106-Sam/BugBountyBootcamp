#!/bin/bash

source libs/scan.lib



# Parse the mode with getopts
while getopts "m:i" OPTION; do
    case $OPTION in
        m)
            MODE=$OPTARG
            ;;
	i)
            INTERACTIVE=true
	    ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))  # Shift positional parameters to get the domain

scan_domain(){
	
	DOMAIN=$1
	DIRECTORY=${DOMAIN}_recon
	echo "Creating directory $DIRECTORY."
	mkdir $DIRECTORY

	# Scan based on mode
        case $MODE in
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
		;;
        esac
}

report_domain(){
	DOMAIN=$1
	DIRECTORY=${DOMAIN}_recon
        echo -e "Generating recon report for $DOMAIN.."
        TODAY=$(date)
        echo -e "This scan was created on $TODAY" > $DIRECTORY/report

        if [ -f $DIRECTORY/nmap ]; then
                echo -e "Results of Nmap:" >> $DIRECTORY/report
                grep -E "^\S+\s+\S+\s+\S*$" $DIRECTORY/nmap >> $DIRECTORY/report
        fi

        if [ -f $DIRECTORY/dirsearch ]; then
                echo -e "Results of Dirsearch:" >> $DIRECTORY/report
                cat $DIRECTORY/dirsearch >> $DIRECTORY/report
        fi

        if [ -f $DIRECTORY/crt ]; then
                echo -e "Results of Cert Parsing:" >> $DIRECTORY/report
                jq -r ".[] | .name_value" $DIRECTORY/crt >> $DIRECTORY/report 
        fi
}

if [ $INTERACTIVE ]; then
	INPUT="BLANK"
	while [ $INPUT != "quit" ];do
	       echo "Please Enter a domain:"
	       read INPUT
	       if [ $INPUT != "quit" ]; then
		       scan_domain $INPUT
		       report_domain $INPUT
	       fi
       done
else 
	for i in "${@:$OPTIND:$#}";do
		scan_domain $i
		report_domain $i
	done
fi
