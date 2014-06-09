# if node["role"] == "app"
#   # do app things
# end

# INSTALL AND DEFINE SERVICES
#package 'nginx'
package 'imagemagick'
package 'redis-server'
package 'git'
package 'monit'


# PATCH /etc/inputrc
template "/tmp/inputrc_append.conf" do
	source "inputrc_append.erb"
end

execute "Append inputrc search with arrow keys" do
	user "root"
	command "cat /tmp/inputrc_append.conf >> /etc/inputrc"
end

execute "Remove inputrc_append" do
	command "rm /tmp/inputrc_append.conf"
end


# Some default files/directories
# directory '/srv/www' do
# 	mode '0755'
# 	owner 'deploy'
# 	group 'www-data'
# 	recursive true
# end

# cookbook_file '/var/pvlb/html/index.html' do
#	 mode '0644'
#	 owner 'root'
#	 group 'root'
# end

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

