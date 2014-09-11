#!/bin/bash

for i in `seq 7001 7032`; do
	cp /etc/redis/6379.conf /etc/redis/$i.conf
	sed -i 's/6379/'${i}'/' /etc/redis/$i.conf; 
done

