# Multiply redis configs
cookbook_file "/tmp/redis_sed_incr.sh" do
	mode '0755'
	owner 'root'
end

execute "Multiply redis configs and remove script" do
  user "root"
  command "/tmp/redis_sed_incr.sh && rm -f /tmp/redis_sed_incr.sh"
  only_if { File.exist?("/tmp/redis_sed_incr.sh") }
end


# Start all redis instances
cookbook_file "/etc/init.d/redis-start-all.sh" do
	mode '0755'
	owner 'root'
end

cookbook_file "/etc/init.d/redis-stop-all.sh" do
	mode '0755'
	owner 'root'
end

execute "Start all redis instances" do
  user "root"
  command "/etc/init.d/redis-start-all.sh"
  only_if { File.exist?("/etc/init.d/redis-start-all.sh") }
end

