#!/bin/bash

#start tshark capture
nohup sudo tshark -i eth1 -b duration:10 -b files:2 -w wall.pcapng &

#Main
while true; do
	packets=$(ls|grep pcap)
	for i in $packets; do
		#HTTP coloring rule (rule1)
		rule1=$(tshark -r $i -Y 'http || tcp.port==80 || http2')
		if [ -z "$rule1" ] ;then
			echo "0" > r1
		else
			echo "1" > r1
			tshark -r $i -Y 'http || tcp.port==80 || http2' -w http.pcapng
		fi

		#sample coloring rule (rule2)
		#rule2=$(tshark -r $i -Y '')
		#if [ -z "$rule2" ] ;then
		#	echo "0" > r2
		#else
		#	echo "1" > r2
		#	tshark -r $i -Y '' -w http.pcapng
		#fi
	done
	sleep 10s
done
