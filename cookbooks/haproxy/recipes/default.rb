# INSTALL AND DEFINE SERVICES
package 'haproxy'

# HAPROXY CONFIG

# This is to make it be able to start
file '/etc/default/haproxy' do
  mode '0644'
  owner 'root'
  group 'root'
  content "ENABLED=1\n"
  notifies :reload, 'service[haproxy]'
end

# The actual config - sourced from
template '/etc/haproxy/haproxy.cfg' do
  mode '0644'
  owner 'root'
  group 'root'
  notifies :reload, 'service[haproxy]'
end


service 'haproxy' do
  supports :reload => true
  action :start
end
