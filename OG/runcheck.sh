#!/bin/bash
COUNTER=0
runcheck=$(ps aux | grep "/check.sh" | grep "/bin/bash")
while [  $COUNTER -lt 10 ]; do
	if [ -z "$runcheck" ]
	then	
		/bin/bash /root/check.sh &
	fi
	sleep 60
done
