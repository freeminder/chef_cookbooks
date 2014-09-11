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
			chown redis	/var/run/redis/$i
		fi


	if [ ! -f $PIDFILE ]
	then
		echo "$PIDFILE does not exist, process is not running"
	else
		PID=$(cat $PIDFILE)
		echo "Stopping ..."

		$CLIEXEC	-p $i shutdown

		while [ -x /proc/${PID} ]
		do
			echo "Waiting for Redis to shutdown ..."
			sleep 1
		done
		echo "Redis stopped"
	fi

done
