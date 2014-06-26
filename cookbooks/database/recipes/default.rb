# INSTALL PACKAGES
package 'mc'
package 'wget'
package 'curl'
package 'git'


# PATCH /etc/inputrc
cookbook_file '/etc/inputrc' do
	 mode '0644'
	 owner 'root'
	 group 'root'
end


# SSH keys for root (shared access between servers)
directory '/root/.ssh' do
	mode '0700'
	owner 'root'
	group 'root'
end

cookbook_file '/root/.ssh/id_rsa' do
	mode '0400'
	owner 'root'
	group 'root'
	source 'root_rsa'
end

cookbook_file '/root/.ssh/id_rsa.pub' do
	mode '0644'
	owner 'root'
	group 'root'
	source 'root_rsa.pub'
end

cookbook_file '/root/.ssh/authorized_keys' do
	mode '0600'
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


# Remote agent for Sublime Text
execute "Download and make executable rsub" do
	user "root"
	command "wget -O /usr/local/bin/rsub https://raw.github.com/aurora/rmate/master/rmate && chmod +x /usr/local/bin/rsub"
	not_if { ::File.exist?('/usr/local/bin/rsub') }
end


# PATCH /etc/hosts
# ruby_block "insert_line" do
# 	block do
# 		file = Chef::Util::FileEdit.new("/etc/hosts")
# 		file.insert_line_if_no_match("/chef/", "10.42.0.6	chef-server.local	chef-server")
# 		file.write_file
# 	end
# end
