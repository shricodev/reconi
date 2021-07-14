#!/bin/bash
echo "[+] A for date"
echo "[+] B for listing contents of the directory"
echo "[+] C for cmatrix"
  read UserInput
    case $UserInput in
    A) date | /opt/notify;;
    B) ls  | /opt/notify;;
    C) cmatrix  | /opt/notify;;
    esac 
