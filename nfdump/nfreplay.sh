#!/usr/bin/env bash

for X in $(find ./nfpcapd -type f); do
	echo -n "$X: " | tee -a nfreplay.log
	RV=$(nfreplay -H 127.0.0.1 -r "$X" -v 9)
	if [ $RV ]; then
		echo "($RV)" | tee -a nfreplay.log
	else
		echo "Success ($RV)" | tee -a nfreplay.log
	fi
done
