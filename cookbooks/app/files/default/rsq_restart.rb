#!/usr/bin/env ruby
# stop and start resque queues
@pids = `ps aux|grep resque|grep -v grep|awk '{ print $2 }'`.split("\n")

def run_resque
	Dir.chdir("/srv/www/sliderapp/current")
	Process.detach( fork { exec "( ( nohup bundle exec rake resque:work TERM_CHILD=1 QUEUES='*' > /dev/null 2>&1 ) & )" } )
	Process.exit(0)
end

def kill_resque
	@pids.each { |pid| Process.kill 9, pid.to_i }
end


if @pids == ""
	run_resque
else
	kill_resque
	run_resque
end

