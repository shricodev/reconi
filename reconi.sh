#!/bin/bash
# Author: Piyush Achärya (r3alix01)
# Date: 2021/07/16
# Usage: This is a small script to run some of my goto tools for reconnaisance.

apt install figlet > /dev/null 2>&1
figlet -c reconi
echo "                                                         @Author: Piyush Achärya"
echo "                                                        https://github.com/r3alix01"
echo "Usage: reconi.sh <options>"
echo "Options: -amass -subfinder -sublist3r -assetfinder -gau -waybackurls -nuclei -nucleiurls -naabu"
echo
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
user=$(who | awk '{print $1}')
echo "${green}Can only use one argument at a time${reset} ${red}(recommended: -all)${reset}"
echo "${green}Developers assume no liability and are not responsible for any misuse or damage caused by this program. Only use for educational purposes.${reset}"
echo "${red}Alert: Run this script as root${reset}"
mkdir reconi_output
cd ./reconi_output
echo
read -p "${green}Enter the domain:${reset} " domain
case "${1}" in
-amass)
echo "${green}[+] Running amass [-active] for subdomain enumeration.${reset}"
echo
amass enum -active -d $domain -o Amass_$domain.txt
;;
-subfinder)
echo
echo "${green}[+] Running subfinder on the target domain.${reset}"
/opt/subfinder -d $domain -all -v |  tee Subfinder_$domain.txt 
;;
-sublist3r)
echo
echo "${green}[+] Running sublist3r on the target domain${reset}"
sublist3r -d $domain -v -o Sublist3r_$domain.txt
;;
-assetfinder)
echo "${green}[+] Running assetfinder on the target domain.${reset}"
/opt/assetfinder --subs-only $domain | tee Assetfinder_$domain.txt
;;
-gau)
echo
echo "${green}[+] Running gau on the target domain.${reset}"
getallurls -subs -v | sort -u | tee Gau_$domain.txt
;;
-waybackurls)
echo
echo "${green}[+] Running waybackurls on the target domain.${reset}"
/opt/waybackurls $domain | tee Waybackurl_$domain.txt
;;
-nuclei)
echo
echo "${green}[+] Running nuclei on the target domain.${reset}"
echo "${red}Alert: It will only run on the target domain not on all sub-domains.${reset}"
/opt/nuclei -u https://$domain -t /root/$user/nuclei-templates -o Nuclei_$domain.txt
;;
-nucleiurls)
echo
echo "${green}[+] Running nuclei on the target url.${reset}"
echo "${red}Alert: This option is supported only after running waybackurls and gau${reset}"
cat gau_$domain.txt waybackurls_$domain.txt | /opt/httpx | tee Liveurls_$domain.txt | /opt/nuclei -l ./Liveurls_$domain.txt -t ~/nuclei-templates -c 100 -o Nucleiurl_$domain.txt
;;
-naabu)
echo
echo "${green}[+] Running naabu on the target domain.${reset}"
/opt/naabu -host $domain | tee Naabu_$domain.txt
;;
-all)
echo
echo "${green}[+] Running all the tools sublist3r, subfinder, amass, assetfinder, gau, waybackurls, nuclei, nucleiurls and naabu${reset}"
echo "${green}[+] Running sublist3r on the target domain${reset}"
sublist3r -d $domain -v -o sublister_$domain.txt
echo
echo "${green}[+] Running subfinder on the target domain.${reset}"
/opt/subfinder -d $domain -all -v |  tee subfinder_$domain.txt
echo
echo "${green}[+] Running assetfinder on the target domain.${reset}"
/opt/assetfinder --subs-only $domain | tee assetfinder_$domain.txt
echo
echo "${green}[+] Running amass for subdomain enumeration.${reset}"
amass enum -active -d $domain -o amass_$domain.txt
echo
echo "${green}[+] Running gau on the target domain.${reset}"
cat amass_$domain.txt subfinder_$domain.txt sublist3r_$domain.txt assetfinder_$domain.txt | sort -u | getallurls | sort -u | tee gau_$domain.txt
echo
echo "${green}[+] Running waybackurls on the target domain.${reset}"
cat amass_$domain.txt subfinder_$domain.txt sublist3r_$domain.txt assetfinder_$domain.txt | sort -u | /opt/waybackurls $domain | sort -u | tee waybackurls_$domain.txt
echo
echo "${green}[+] Running nuclei on the target domain.${reset}"
cat amass_$domain.txt subfinder_$domain.txt sublist3r_$domain.txt assetfinder_$domain.txt | sort -u | tee allsubs_$domain.txt | /opt/httpx -silent | tee liveallsubs_$domain.txt
/opt/nuclei -l ./liveallsubs_$domain.txt -t ~/nuclei-templates -c 100 -o nucleisubs_$domain.txt
echo
echo "${green}[+] Running naabu on the list of domains.${reset}"
/opt/naabu -iL liveallsubs_$domain.txt | tee naabulive_$domain.txt
echo
echo "${green}[+] Running nuclei on the given urls.${reset}"
cat gau_$domain.txt waybackurls_$domain.txt | /opt/httpx | egrep -v '(.js|.png|.svg|.jpeg|.jpg|.gif)' | tee liveurls_$domain.txt | /opt/nuclei -l ./liveurls_$domain.txt -t ~/nuclei-templates
;;
esac
