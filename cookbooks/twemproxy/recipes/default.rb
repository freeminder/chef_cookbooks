#
# Cookbook Name:: twemproxy
# Recipe:: default
#
# Author:: Daniel Koepke (<daniel.koepke@kwarter.com>)
#
# Copyright 2013, Kwarter, Inc.
#

include_recipe "twemproxy::#{node[:twemproxy][:install_method]}"

template "nutcracker-conf" do
    path node[:twemproxy][:config_file]
    source "nutcracker.conf.erb"
    mode 0644
    variables :sections => node[:twemproxy][:config]
    notifies :restart, "service[nutcracker]"
end

service "nutcracker" do
    action [:enable, :start]
    supports :reload => true, :restart => true, :status => true
    subscribes :restart, resources(:template => "nutcracker-conf")
end


# Sentinel
execute "touch /var/log/sentinel.log; chown redis /var/log/sentinel.log" do
  not_if { File.exist?("/var/log/sentinel.log") }
end

template "sentinel" do
  path "/etc/init.d/sentinel"
  source "sentinel.init.erb"
  mode 0755
end

template "sentinel-conf" do
		path "/etc/redis/sentinel.conf"
    source "sentinel.conf.erb"
    mode 0666
    notifies :stop, "service[sentinel]"
    notifies :start, "service[sentinel]"
end

service "sentinel" do
    action [:enable, :start]
    supports :start => true, :stop => true
    subscribes :start, resources(:template => "sentinel-conf")
end


# # Redis-mgr
# execute "mkdir /opt/redis-mgr && cd /opt/redis-mgr && \
# apt-get -y install git python python-pip && \
# pip install redis && \
# pip install -e git://github.com/idning/pcl.git#egg=pcl && \
# pip install -e git://github.com/kislyuk/argcomplete.git#egg=argcomplete && \
# git clone https://github.com/idning/redis-mgr.git ." do
#   not_if { Dir.exist?("/opt/redis-mgr") }
# end

