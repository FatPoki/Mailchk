#!/bin/bash

if [ "$1" = "-h" ]; then
echo -e " \n   \033[31m Email Header Analyzer \033[0m
\n Usage: \n
  mailchk.sh  <email_file>

\n Description: \n 
  Analyzes email headers (.eml, .msg, .emlx) to extract sender,
  receiver, IP address, and authentication results to speed up the process.

\n Options: \n 
  -h    Show this help message and exit

\n Example: \n
  ./mailchk.sh suspicious.eml
"
    exit 0
fi

shopt -s extglob
file=$1

if [ ! -f "$file" ]; then
    echo -e " \n $file does not exists ,  use -h for help menu \n "
    exit 1
elif [[ "$file" != *.@(eml|msg|emlx) ]]; then
    echo -e " '$file' exist but dosnt looks like email file.\n"
    exit 1
fi

echo -e " \n Chcking details... \n " && sleep 2 && clear
figlet Header Analysis | lolcat && echo "" && sleep 2

echo -e  " \n                                 \033[36mDetails \033[0m  \n " | pv -qL 25

# Receiver
RE=$(sed -n 's/^To: //p' "$file" | head -n 1 | tr -d '\r' | cut -d "<" -f2 | cut -d ">" -f1)
if grep -q "To: " "$file"; then
    echo -e "Reciver     : $RE \n"
else
    echo -e " No email found in '$file'.\n"
fi

# Sender
if grep -q "From:" "$file"; then
    SE=$(grep "^From:" "$file" | cut -d'<' -f2 | cut -d'>' -f1 | tr -d '\r')
    echo -e "Sender      : $SE\n"
else
    echo -e " No email header found in '$file'.\n"
fi

if grep -q "Return-Path:" "$file"; then
    RP=$(grep "Return-Path:" "$file" | cut -d "<" -f2 | cut -d ">" -f1 | tr -d '\r')
    echo -e "Return path : $RP \n "
else
    echo -e " No return path found.\n"
fi

# IP
ip=$(grep -iE "ip|client-ip|X-Sender-IP" "$file" | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | head -n 1)
[ -n "$ip" ] && echo "Sender IP   : $ip" || echo "no ip address found"
echo ""

# SPF / DKIM / DMARC
passes=$(grep -ci "spf=pass" "$file")
fails=$(grep -ci "spf=fail" "$file")

dkimp=$(grep -ci "dkim=pass" "$file")
dkimf=$(grep -ci "dkim=fail" "$file")

dmarcp=$(grep -ci "dmarc=pass" "$file")
dmarcf=$(grep -ci "dmarc=fail" "$file")

echo -e  " \n                        \033[36mARC Authentication Checks\033[0m  \n " | pv -qL 25

[ "$passes" -gt 0 ] && [ "$fails" -eq 0 ] && echo "spf check   : Pass" || echo "spf check   : Failed / Forwarded"
[ "$dkimp" -gt 0 ] && [ "$dkimf" -eq 0 ] && echo "DKIM check  : Pass" || echo "DKIM check  : Failed / Forwarded"

if [ "$dmarcp" -gt 0 ] && [ "$dmarcf" -eq 0 ]; then
    echo "Dmarc check : pass"
elif [ "$dmarcf" -gt 0 ]; then
    echo "Dmarc check : fail"
else
    echo "Dmarc check : Temporary Error , from mail server side."
fi

echo ""
echo -e "\033[31m--------------------------------------------------------------------------------\033[0m"
echo ""

if [[ "$passes" -ge 1 && "$fails" -eq 0 \
   && "$dkimp" -ge 1 && "$dkimf" -eq 0 \
   && "$dmarcp" -ge 1 && "$dmarcf" -eq 0 ]]; then
    echo "ARC authentication passed. Mail looks safe."
else
    echo "ARC authentication failed. Mail looks suspicious."
fi


echo ""
read -p "Please press 'y' to extract attachment hash value from '$file' and any other key to skip:  " extr
echo ""

if [[ "$extr" == "y" || "$extr" == "Y" ]]; then
    ripmime -i "$file" -d attachment
    rm -fr ./attachment/textfile*

    echo -e  "\n                        \033[36mSHA256 hash value\033[0m  \n " | pv -qL 25
     sha=$(sha256sum attachment/*)
    echo -e "\n$sha\n" | tr -d "\r"
    echo -e  "\n                        \033[36mMD5 hash value\033[0m  \n " | pv -qL 25

     md5=$(md5sum attachment/*)
     echo -e"\n$md5\n" | tr -d "\r"

    rm -rf attachment
else
    echo "Skipping process"
fi


echo ""
read -p "Do you need attachment extracted for personal analysis? (y/n): " personal
echo ""

analysis_dir="personal_analysis"
marker_file="$analysis_dir/.$(basename "$file").done"

if [[ "$personal" == "y" || "$personal" == "Y" ]]; then
    mkdir -p "$analysis_dir"

    if [ -f "$marker_file" ]; then
        echo "Attachment for this email already exists in '$analysis_dir'."
        echo "Exiting to avoid duplicate extraction."
        exit 0
    fi

    echo "Extracting attachment for personal analysis..."
    ripmime -i "$file" -d "$analysis_dir"
    rm -f "$analysis_dir"/textfile*
    touch "$marker_file"

    echo ""
    echo "Please find the attachment inside: $analysis_dir"
    echo "Note: Perform further analysis and do not rely on a single tool."
else
    echo "No personal extraction requested. Exiting normally."
    echo ""
    echo "Note: Results are indicative only. Perform further analysis and avoid relying on a single tool."

fi
