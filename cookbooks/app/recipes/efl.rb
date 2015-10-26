# if node["role"] == "app"
#  # do app things
# end

case node['platform_family']
when 'debian'
  apt_package 'libmysqlclient-dev'
  apt_package 'htop'
when 'rhel', 'fedora'
  yum_package 'mysql-devel'
end


# INSTALL AND DEFINE SERVICES
gem_package 'bundler'


# Some default files/directories
directory "#{node.default['app']['app_path']}" do
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

%w{ database.yml local_env.yml secrets.yml }.each do |file|
  cookbook_file "#{node.default['app']['app_path']}/shared/config/#{file}" do
    mode '0644'
    owner 'deploy'
    group 'www-data'
  end
end

Dir[ "/srv/www/**/*" ].each do |path|
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
cron "sync_time" do
  hour "1"
  minute "0"
  environment my_env_vars
  command "ntpdate -s pool.ntp.org"
end


# NGINX CONFIG
template '/etc/nginx/nginx.conf' do
   mode '0644'
   owner 'root'
   group 'root'
   notifies :reload, 'service[nginx]'
end

# service 'nginx' do
#    supports :reload => true
#    action :start
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
