#!/bin/bash
cd /root/URL_Beers
COUNTER=0
while [  $COUNTER -lt 10 ]; do
	curl -s https://shop.cantillon.be/en/28598-beers -o current.txt
	newmd5=$(md5sum current.txt | grep -Eo "^[0-9a-f]*")
	oldmd5=$(md5sum old.txt | grep -Eo "^[0-9a-f]*")
	dt=$(date '+%d/%m/%Y_%H:%M:%S')
	dts=$(date '+%d-%m-%Y_%H-%M-%S')
	wd=$(wdiff -123 -s old.txt current.txt)
	change=$(echo $wd | grep -Eo "[0-9]*% changed" | grep -Eo "[0-9]*" | grep -Eo "[^0]*")
	if [ -z "$change" ]
	then
		echo "" > /dev/null
	else
		echo "" > email.txt
		sleep 0.5
		cat /root/URL_Beers/ChangeDetected.txt > email.txt
		sleep 0.5
		echo $wd >> email.txt
		sleep 0.5
		mail -s "Cantillon Change" lucasballek@gmail.com < email.txt
		sleep 1
		echo "Change Found $dt (UDT) - $change" >> changelog.txt 
		cp current.txt /root/URL_Beers/results/"$dts".txt
		sleep 1
		mv current.txt old.txt
		
	fi
	
	sleep 30
done
