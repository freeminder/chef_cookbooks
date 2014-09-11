# redis-twemproxy-agent-master deps install
case node['platform_family']
when 'debian'
	apt_package 'nodejs'
	apt_package 'nodejs-legacy'
	apt_package 'npm'
when 'rhel', 'fedora'
	yum_package 'nodejs'
	yum_package 'npm'
end

# redis-twemproxy-agent-master installation
execute "cd /opt && tar zxvf /tmp/redis-twemproxy-agent-master.tgz && rm -f /tmp/redis-twemproxy-agent-master.tgz" do
  only_if { File.exist?("/tmp/redis-twemproxy-agent-master.tgz") }
end

# redis-twemproxy-agent-master start
execute "cd /opt/redis-twemproxy-agent-master && nohup /opt/redis-twemproxy-agent-master/bin/redis_twemproxy_agent &" do
  only_if { File.exist?("/opt/redis-twemproxy-agent-master/bin/redis_twemproxy_agent") }
end

# redis-twemproxy-agent-master add to startup
execute "echo 'nohup /opt/redis-twemproxy-agent-master/bin/redis_twemproxy_agent &' >> /etc/rc.local" do
  only_if { File.exist?("/opt/redis-twemproxy-agent-master/bin/redis_twemproxy_agent") }
end

