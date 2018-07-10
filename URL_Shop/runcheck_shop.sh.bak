#!/bin/bash
COUNTER=0
runcheck=$(ps aux | grep "/check_shop.sh" | grep "/bin/bash")
while [  $COUNTER -lt 10 ]; do
	if [ -z "$runcheck" ]
	then	
		/bin/bash /root/URL_Shop/check_shop.sh &
	fi
	sleep 60
done
