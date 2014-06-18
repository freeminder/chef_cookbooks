# if node["role"] == "app"
#   # do app things
# end

case node['platform_family']
when 'debian'
	apt_package 'libmysqlclient-dev'
when 'rhel', 'fedora'
	yum_package 'mysql-devel'
end


# INSTALL AND DEFINE SERVICES
package 'imagemagick'
package 'redis-server'
package 'monit'
gem_package 'bundler'



# Some default files/directories
%w{ bin config log tmp }.each do |dir|
	directory "#{node.default['app']['app_path']}/shared/#{dir}" do
		mode '0755'
		owner 'deploy'
		group 'www-data'
		action :create
		recursive true
	end
end

# directory "/srv/www/sliderapp" do
#   owner "deploy"
#   group "www-data"
#   recursive true
# end
Dir[ "/srv/www/**/*" ].each do |path|
  # file path do
  #   owner "deploy"
  #   group "www-data"
  # end if File.file?(path)
  directory path do
    owner "deploy"
    group "www-data"
  end if File.directory?(path)
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
  command "cd #{node.default['app']['app_path']}/current && bundle exec rake timeout:swapbreak"
end


# Install SSL cert&key
%w{ dev.swapslider.com.crt dev.swapslider.com.key }.each do |file|
	cookbook_file "/etc/nginx/#{file}" do
		mode '0600'
		owner 'deploy'
		group 'www-data'
	end
end

# execute "Phusion Passenger final install" do
# 	user "root"
# 	command "cd /usr/local/rvm/gems/ruby-2.1.2/gems/passenger-4.0.45 && export rvmsudo_secure_path=1 rvmsudo rake nginx"
# end

# NGINX CONFIG
template '/etc/nginx/nginx.conf' do
	 mode '0644'
	 owner 'root'
	 group 'root'
	 notifies :reload, 'service[nginx]'
end

# service 'nginx' do
# 	 supports :reload => true
# 	 action :start
# end


cookbook_file "#{node.default['app']['app_path']}/shared/bin/resque_service.rb" do
	mode '0755'
	owner 'deploy'
	group 'www-data'
end

execute "resque service" do
	user "deploy"
	command "ruby #{node.default['app']['app_path']}/shared/bin/resque_service.rb"
	returns [0, 2, nil]
	not_if { ::File.exists?("#{node.default['app']['app_path']}/releases")}
end


# file '/var/pvlb/html/health.txt' do
#	 mode '0644'
#	 owner 'root'
#	 group 'root'
#	 content "OK\n"
# end
