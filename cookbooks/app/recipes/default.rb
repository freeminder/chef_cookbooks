# if node["role"] == "app"
#	 # do app things
# end

case node['platform_family']
when 'debian'
	apt_package 'libmysqlclient-dev'
when 'rhel', 'fedora'
	yum_package 'mysql-devel'
end


# INSTALL AND DEFINE SERVICES
package 'imagemagick'
gem_package 'bundler'


# Some default files/directories
directory "#{node.default['app']['app_path']}" do
	mode '0755'
	owner "deploy"
	group "www-data"
	recursive true
end

directory "#{node.default['app']['app_dc_path']}" do
	mode '0755'
	owner "deploy"
	group "www-data"
	recursive true
end


%w{ releases shared }.each do |dir|
	directory "#{node.default['app']['app_path']}/#{dir}" do
		mode '0755'
		owner 'deploy'
		group 'www-data'
		action :create
		recursive true
	end
	directory "#{node.default['app']['app_dc_path']}/#{dir}" do
		mode '0755'
		owner 'deploy'
		group 'www-data'
		action :create
		recursive true
	end
end

%w{ bin config log tmp }.each do |dir|
	directory "#{node.default['app']['app_path']}/shared/#{dir}" do
		mode '0755'
		owner 'deploy'
		group 'www-data'
		action :create
		recursive true
	end
end

directory "#{node.default['app']['app_dc_path']}/shared/config" do
	mode '0755'
	owner 'deploy'
	group 'www-data'
	action :create
	recursive true
end

%w{ database.yml local_env.yml secrets.yml }.each do |file|
	cookbook_file "#{node.default['app']['app_path']}/shared/config/#{file}" do
		mode '0644'
		owner 'deploy'
		group 'www-data'
	end
end

cookbook_file "#{node.default['app']['app_dc_path']}/shared/config/database.yml" do
	source 'database_dc.yml'
	mode '0644'
	owner 'deploy'
	group 'www-data'
end

Dir[ "/srv/www/**/*" ].each do |path|
	# file path do
	#	 owner "deploy"
	#	 group "www-data"
	# end if File.file?(path)
	directory path do
		owner "deploy"
		group "www-data"
	end if File.directory?(path)
end


# Create a cronjob
my_env_vars = { 
	"SHELL" => "/bin/bash",
	"PATH" => "/usr/local/rvm/gems/ruby-2.1.2/bin:/usr/local/rvm/gems/ruby-2.1.2@global/bin:/usr/local/rvm/rubies/ruby-2.1.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/rvm/bin",
	"GEM_HOME" => "/usr/local/rvm/gems/ruby-2.1.2",
	"GEM_PATH" => "/usr/local/rvm/gems/ruby-2.1.2:/usr/local/rvm/gems/ruby-2.1.2@global"
}
cron "swapbreak" do
	hour "3"
	minute "0"
	environment my_env_vars
	command "cd #{node.default['app']['app_path']}/current && bundle exec rake timeout:swapbreak"
end
cron "notify_immature" do
	hour "*/03"
	minute "0"
	environment my_env_vars
	command "cd #{node.default['app']['app_path']}/current && rake phones:notify_immature"
end
cron "sync_time" do
	hour "1"
	minute "0"
	environment my_env_vars
	command "ntpdate -s pool.ntp.org"
end


# Install SSL cert&key for nginx
%w{ dev.swapslider.com.crt dev.swapslider.com.key }.each do |file|
	cookbook_file "/etc/nginx/#{file}" do
		mode '0600'
		owner 'deploy'
		group 'www-data'
	end
end

# Setup SSL for access to Percona XtraDB Cluster
%w{ ca.pem client-cert.pem client-key.pem }.each do |file|
  cookbook_file "/etc/mysql/#{file}" do
    mode '0640'
    owner 'root'
    group 'www-data'
  end
end


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


cookbook_file "#{node.default['app']['app_path']}/shared/bin/rsq_restart.rb" do
	mode '0755'
	owner 'deploy'
	group 'www-data'
end


# Fix permissions for gems, especially rake
execute "Fix permissions for gems" do
  user "root"
  command "chown -R :rvm /usr/local/rvm/gems/ruby-2.1.2/gems/ && chmod -R g+w /usr/local/rvm/gems/ruby-2.1.2/gems/"
  only_if { File.exist?("/usr/local/rvm/gems/ruby-2.1.2/gems/") }
end


# execute "resque service" do
# 	user "deploy"
# 	command "ruby #{node.default['app']['app_path']}/shared/bin/resque_service.rb"
# 	returns [0, 2, nil]
# 	not_if { ::File.exists?("#{node.default['app']['app_path']}/releases")}
# end


# file '/var/pvlb/html/health.txt' do
#	 mode '0644'
#	 owner 'root'
#	 group 'root'
#	 content "OK\n"
# end


include_recipe 'app::firewall'

