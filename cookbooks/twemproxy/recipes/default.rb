#
# Cookbook Name:: twemproxy
# Recipe:: default
#
# Author:: Daniel Koepke (<daniel.koepke@kwarter.com>)
#
# Copyright 2013, Kwarter, Inc.
#

include_recipe "twemproxy::#{node[:twemproxy][:install_method]}"

include_recipe "twemproxy::redis_incr"

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



# include_recipe "twemproxy::sentinel"


# # Redis-mgr
# execute "mkdir /opt/redis-mgr && cd /opt/redis-mgr && \
# apt-get -y install git python python-pip && \
# pip install redis && \
# pip install -e git://github.com/idning/pcl.git#egg=pcl && \
# pip install -e git://github.com/kislyuk/argcomplete.git#egg=argcomplete && \
# git clone https://github.com/idning/redis-mgr.git ." do
#   not_if { Dir.exist?("/opt/redis-mgr") }
# end

