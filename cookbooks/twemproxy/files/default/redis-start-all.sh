#!/bin/bash
ulimit -n 10032

for i in `seq 7001 7032`; do

	REDISNAME=$i
	REDISPORT=$i
	EXEC="sudo -u redis /usr/local/bin/redis-server /etc/redis/${REDISNAME}.conf"
	CLIEXEC=/usr/local/bin/redis-cli

	PIDFILE=/var/run/redis/$i/redis.pid

	if [ ! -d /var/run/redis/$i ]; then
	    mkdir -p /var/run/redis/$i
	    chown redis  /var/run/redis/$i
	fi


	if [ -f $PIDFILE ]
	then
	        echo "$PIDFILE exists, process is already running or crashed"
	else
	        echo "Starting Redis server..."
	        eval $EXEC
	fi

done
