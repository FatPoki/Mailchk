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

elif [[ "$file"  != *.@(eml|msg|emlx) ]]; then
    echo -e " '$file' exist but dosnt looks like email file.\n"

else

#                                       UNCOMMENT ME 

echo -e " \n Chcking details... \n " &&  sleep 2 && clear 

figlet Header Analysis | lolcat  && echo " " &&  sleep 2



echo -e  " \n                                 \033[36mDetails \033[0m  \n " |  pv -qL 25


        # check for Reciver email header
    RE=$(sed -n 's/^To: //p' "$file"  | head -n 1 | tr -d '\r' | cut -d "<" -f2  | cut -d ">" -f1 )
    
    if grep -q "To: " "$file"; then
        echo -e "Reciver     : $RE \n" 
        
    else
            echo -e " No email  found in '$file'.\n"
    fi
        # end check for reciver email header

        # check for Sender email header


        if grep -q "From:" "$file"; then
        
        SE=$(grep "^From:" "$file" | cut -d'<' -f2 | cut -d'>' -f1 | tr -d '\r')

        echo -e "Sender      : $SE\n"
        else
            echo -e " No email header found in '$file'.\n"
        fi

        # end check for sender email header

        #check for return path email header

        if grep -q "Return-Path:" "$file"; then
        
        RP=$(grep  "Return-Path:" "$file" | cut -d "<" -f2 | cut -d ">" -f1 | tr -d '\r')
        
        echo -e "Return path : $RP \n "
        
        else
        
        echo -e " No return path found.\n"

        fi
        # end for return path check.

        # check for ip 

ip=$(grep -iE "ip|client-ip|X-Sender-IP" "$file" | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}" | head -n 1)

if [ -n "$ip" ]; then
    echo "Sender IP   : $ip"
else
    echo "no ip address found"
fi
    echo "" 

    # end of ip check 

        # spf check

        passes=$(grep -ci "spf=pass" "$file")
        fails=$(grep -ci "spf=fail" "$file")
echo "" 
echo -e  " \n                        \033[36mARC Authentication Checks\033[0m  \n " |  pv -qL 25


        if [ "$passes" -gt 0 ] && [ "$fails" -gt 0 ]; then
        echo -e " spf check   : Email looks forworded."
        elif [ "$passes" -gt 0 ]; then
        echo "spf check   : Pass"
        else 
        echo "spf check   : Failed"
        fi
echo ""
        #end of spf check 

        #DKIM check 
        dkimp=$(grep -ci "dkim=pass" "$file")
        dkimf=$(grep -ci "dkim=fail" "$file")

        if [ "$dkimp" -gt 0 ] && [ "$dkimf" -gt 0 ]; then
        echo -e " DKIM check : Email looks forworded."
        elif [ "$passes" -gt 0 ]; then
        echo "DKIM check  : Pass"
        else 
        echo "DKIM check  : Failed"
        fi
                # end of DKIM check 
                
echo ""
        # dmarc check 
dmarcp=$(grep -ci "dmarc=pass" "$file")
dmarcf=$(grep -ci "dmarc=fail" "$file")      

if [ "$dmarcp" -gt 0 ] && [ "$dmarcf" -gt 0 ]; then 
echo ""
    echo  "DMARC status: Mixed/Suspicious (Pass: $dmarcp, Fail: $dmarcf)" 
elif [ "$dmarcp" -gt 0 ]; then 
    echo "Dmarc check : pass"
elif [ "$dmarcf" -gt 0 ]; then
    echo "Dmarc check : fail"
else 
    echo "Dmarc check : Temporary Error , from mail server side."
fi
echo ""
        # end of dmarc check 

echo -e "\033[31m--------------------------------------------------------------------------------\033[0m"
echo ""
if [[ "$passes" -ge 1 && "$dkimp" -ge 1 && "$dmarcp" -ge 1 ]]; then
    echo "ARC authentication passed. Mail looks safe."
else
    echo "ARC authentication failed. Mail looks suspicious."
fi

fi
