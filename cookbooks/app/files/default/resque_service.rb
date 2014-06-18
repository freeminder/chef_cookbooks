#!/usr/bin/env ruby
# stop and start resque queues

unless `ps aux|grep resque|grep -v grep|awk '{ print $2 }'` == ""
	fork { exec "kill -9 `ps aux|grep resque|grep -v grep|awk '{ print $2 }'`" }
	Process.wait
	Process.exit(0)
end

`cd /srv/www/sliderapp/current; ( ( nohup bundle exec rake resque:work TERM_CHILD=1 QUEUES='*' > /dev/null 2>&1 ) & )`
