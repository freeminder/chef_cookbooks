# INSTALL PACKAGES
package 'mc'
package 'wget'
package 'curl'
package 'git'
package 'sysv-rc-conf' if node['platform_family'] == 'debian'
package 'fail2ban'

# PATCH /etc/inputrc
cookbook_file '/etc/inputrc' do
   mode '0644'
   owner 'root'
   group 'root'
end

# SYSCTL tuning
template "/tmp/sysctl_append.conf" do
  source "sysctl_append.erb"
end

execute "Tune sysctl.conf" do
  user "root"
  command "cat /tmp/sysctl_append.conf >> /etc/sysctl.conf && sysctl -p"
end

execute "Remove sysctl_append" do
  command "rm /tmp/sysctl_append.conf"
end


# APPEND /etc/hosts
template "/tmp/hosts_append.conf" do
  source "hosts_append.erb"
end

execute "Append hosts with our servers" do
  user "root"
  command "cat /tmp/hosts_append.conf >> /etc/hosts"
end

execute "Remove hosts_append" do
  command "rm /tmp/hosts_append.conf"
end

# APPEND /etc/bash.bashrc
template "/tmp/bashrc_append.conf" do
  source "bashrc_append.erb"
end

execute "Append bashrc with new aliases" do
  user "root"
  command "cat /tmp/bashrc_append.conf >> /etc/bash.bashrc"
end

execute "Remove bashrc_append" do
  command "rm /tmp/bashrc_append.conf"
end

# Midnight Commander dark theme
directory '/root/.local/share/mc/skins' do
  mode '0755'
  owner 'root'
  group 'root'
  action :create
  recursive true
end

cookbook_file '/root/.local/share/mc/skins/ajnasz-blue.ini' do
  mode '0640'
  owner 'root'
  group 'root'
  source 'ajnasz-blue.ini'
end


# Remote agent for Sublime Text
execute "Download and make executable rsub" do
  user "root"
  command "wget -O /usr/local/bin/rsub https://raw.github.com/aurora/rmate/master/rmate && chmod +x /usr/local/bin/rsub"
  not_if { ::File.exist?('/usr/local/bin/rsub') }
end
