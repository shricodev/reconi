#!/bin/bash
# Author: Piyush Acharya(ReAl_I)
# Date: 2021/07/16
# Usage: This is a small script to run some of my goto tools for reconnaisance.

apt install figlet > /dev/null 2>&1
figlet -c reconi
echo "                                                          @Author: Piyush Acharya"
echo "                                                        https://github.com/realix01"
echo "Usage: reconi.sh <options>"
echo "Options: -amass -gau -waybackurls -nuclei -nucleiurls -naabu -all"
echo
read -p "Enter the domain: " domain
case "${1}" in
-amass)
echo "[+] Running amass for subdomain enumeration."
echo
amass enum -active -d $domain -o domains.txt
;;
-subfinder)
echo
echo "[+] Running subfinder on the target domain."
subfinder -d $domain -all -v
;;
-gau)
echo
echo "[+] Running gau on the target domain."
getallurls -subs > urls.txt
;;
-waybackurls)
echo
echo "[+] Running waybackurls on the target domain."
/opt/waybackurls -v >> urls.txt | cat urls.txt
;;
-nuclei)
echo
echo "[+] Running nuclei on the target domain."
/opt/nuclei -t ~/nuclei-templates -u $domain
;;
-nucleiurls)
echo
echo "[+] Running nuclei on the given urls."
/opt/nuclei -t ~/nuclei-templates -l urls.txt
;;
-naabu)
echo
echo "[+] Running naabu on the list of domains."
/opt/naabu -p -host $domain
;;
-all)
echo
echo "[+] Running every tools on the target domain"
echo
echo "[+] Running amass for subdomain enumeration."
amass enum -active -d $domain -v -nolocaldb -o domains.txt
echo
echo "[+] Running subfinder on the target domain."
subfinder -d $domain -all -v >> domains.txt
echo "[+] Sorting unique sub-domains"
cat domains.txt | sort -u | uniq > domains_sorted.txt | cat domains_sorted.txt
echo
echo "[+] Running gau on the target domain." 
cat domains_sorted.txt | getallurls > urls.txt
echo
echo "[+] Running waybackurls on the target domain."
cat domains_sorted.txt | /opt/waybackurls -v >> urls.txt | cat urls.txt
echo
echo "[+] Running nuclei on the target domain."
/opt/nuclei -t ~/nuclei-templates -l domains_sorted.txt
echo
echo "[+] Running nuclei on the given urls."
/opt/nuclei -t ~/nuclei-templates -l urls.txt
echo
echo "[+] Running naabu on the list of domains."
/opt/naabu -iL -p domains_sorted.txt
;;
esac
