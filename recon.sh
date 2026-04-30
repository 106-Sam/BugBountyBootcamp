#!/bin/bash

nmap $1
cd ~/dirsearch/
source venv/bin/activate
python3 ~/dirsearch/dirsearch.py -u $1 -e php
deactivate
