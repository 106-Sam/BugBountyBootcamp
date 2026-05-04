#!/bin/bash

source libs/scan.lib

DOMAIN=$1
DIRECTORY="${DOMAIN}_recon"
PATH_TO_DIRSEARCH=~/dirsearch


# Parse the mode with getopts
while getopts "m:" OPTION; do
    case $OPTION in
        m)
            MODE=$OPTARG
            ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))  # Shift positional parameters to get the domain

for DOMAIN in "$@"
do
        DIRECTORY="${DOMAIN}_recon"
        echo "Creating directory $DIRECTORY."
        mkdir -p $DIRECTORY

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
        esac

        echo -e "Generating recon report for $DOMAIN..\n"
        TODAY=$(date)
        echo -e "This scan was created on $TODAY \n" > $DIRECTORY/report

        if [ -f $DIRECTORY/nmap ]; then
                echo -e "Results of Nmap:\n" >> $DIRECTORY/report
                grep -E "^\S+\s+\S+\s+\S*$" $DIRECTORY/nmap >> $DIRECTORY/report
        fi

        if [ -f $DIRECTORY/dirsearch ]; then
                echo -e "Results of Dirsearch:\n" >> $DIRECTORY/report
                cat $DIRECTORY/dirsearch >> $DIRECTORY/report
        fi

        if [ -f $DIRECTORY/crt ]; then
                echo -e "Results of Cert Parsing:\n" >> $DIRECTORY/report
                jq -r ".[] | .name_value" $DIRECTORY/crt >> $DIRECTORY/report 
        fi
done
