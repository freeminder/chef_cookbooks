# if node["role"] == "app"
#   # do app things
# end

# INSTALL AND DEFINE SERVICES
package 'nginx'
package 'imagemagick'
package 'redis-server'
package 'monit'

# Create a user
user "deploy" do
  comment "User for deployment"
  gid "adm"
  home "/home/deploy"
  shell "/bin/bash"
  password "$1$zXNyUjfV$JU.t4NkqTaZfrMFKuhImU0"
  supports manage_home: true
end


# Some default files/directories

%w{ config log tmp }.each do |dir|
	directory "#{node.default['app']['app_path']}/shared/#{dir}" do
		mode '0755'
		owner 'deploy'
		group 'www-data'
		action :create
		recursive true
	end
end

%w{ database.yml local_env.yml secrets.yml }.each do |file|
	cookbook_file "#{node.default['app']['app_path']}/shared/config/#{file}" do
		mode '0644'
		owner 'deploy'
		group 'www-data'
	end
end


# Create a cronjob
cron "swapbreak" do
  hour "3"
  minute "0"
  command "cd /srv/www/sliderapp/current && bundle exec rake timeout:swapbreak"
end


# Install SSL cert&key
%w{ dev.swapslider.com.crt dev.swapslider.com.key }.each do |file|
	cookbook_file "/etc/nginx/#{file}" do
		mode '0600'
		owner 'deploy'
		group 'www-data'
	end
end



# file '/var/pvlb/html/health.txt' do
#	 mode '0644'
#	 owner 'root'
#	 group 'root'
#	 content "OK\n"
# end

# NGINX CONFIG
template '/etc/nginx/nginx.conf' do
	 mode '0644'
	 owner 'root'
	 group 'root'
	 notifies :reload, 'service[nginx]'
end

service 'nginx' do
	 supports :reload => true
	 action :start
end

