#!/bin/bash
COUNTER=0
runcheck=$(ps aux | grep "/check_beers.sh" | grep "/bin/bash")
while [  $COUNTER -lt 10 ]; do
	if [ -z "$runcheck" ]
	then	
		/bin/bash /root/URL_Beers/check_beers.sh &
	fi
	sleep 60
done
