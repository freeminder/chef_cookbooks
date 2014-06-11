# if node["role"] == "app"
#   # do app things
# end

# INSTALL AND DEFINE SERVICES
#package 'nginx'
apt_package 'imagemagick'
apt_package 'redis-server'
apt_package 'git'
apt_package 'monit'


# Some default files/directories
# directory '/srv/www' do
# 	mode '0755'
# 	owner 'deploy'
# 	group 'www-data'
# 	recursive true
# end

%w{ config log tmp }.each do |dir|
	directory "/srv/www/sliderapp/shared/#{dir}" do
		mode '0755'
		owner 'deploy'
		group 'www-data'
		action :create
		recursive true
	end
end


cookbook_file '/srv/www/sliderapp/shared/config/database.yml' do
	mode '0644'
	owner 'deploy'
	group 'www-data'
end

# file '/var/pvlb/html/health.txt' do
#	 mode '0644'
#	 owner 'root'
#	 group 'root'
#	 content "OK\n"
# end

# # NGINX CONFIG
# template '/etc/nginx/nginx.conf' do
#	 mode '0644'
#	 owner 'root'
#	 group 'root'
#	 notifies :reload 'service[nginx]'
# end

# service 'nginx' do
#	 supports :reload => true
#	 action :start
# end

