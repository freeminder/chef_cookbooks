#!/bin/sh
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.
#
# description: Redis is an in memory key-value store database
#
### BEGIN INIT INFO
# Provides: redis$i
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: redis$i init script
### END INIT INFO


case "$1" in
    start)
        /etc/init.d/redis-start-all.sh
        ;;
    stop)
        /etc/init.d/redis-stop-all.sh
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac
