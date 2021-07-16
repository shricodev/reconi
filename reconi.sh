#!/bin/bash
#Author: Piyush Acharya(ReAl_I)
#Date: 2021/07/16
#Usage: This is a small script to run some of my goto tools for reconnaisance.

apt install figlet > /dev/null 2>&1
figlet -c Recon_I
echo "                                                          @Author: Piyush Acharya"
echo "                                                        https://github.com/realix01"
echo
echo "Usage: reconi.sh <options> all "
echo "Options: amass gau waybackurls nuclei nucleiurls naabu'
read -p "Enter the domain: " UserInput
domain=$UserInput
case "${1}" in
amass)
amass enum -active -d $domain -o domains.txt | /opt/notify 
;;
gau)
cat domains.txt | getallurls > urls.txt | /opt/notify
;;
waybackurls)
cat domains.txt | waybackurls >> urls.txt | cat urls.txt | /opt/notify
;;
nuclei)
/opt/nuclei -t ~/nuclei-templates -l domains.txt | /opt/notify
;;
nucleiurls)
/opt/nuclei -t ~/nuclei-templates -l urls.txt | /opt/notify
;;
naabu)
/opt/naabu -iL domains.txt | /opt/notify
esac
