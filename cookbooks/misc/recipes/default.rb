# INSTALL AND DEFINE SERVICES
apt_package 'mc'
apt_package 'git'
apt_package 'curl'
apt_package 'wget'

cookbook_file '/etc/inputrc' do
	 mode '0644'
	 owner 'root'
	 group 'root'
end


# PATCH /etc/inputrc
# template "/tmp/inputrc_append.conf" do
# 	source "inputrc_append.erb"
# end

# execute "Append inputrc search with arrow keys" do
# 	user "root"
# 	command "cat /tmp/inputrc_append.conf >> /etc/inputrc"
# end

# execute "Remove inputrc_append" do
# 	command "rm /tmp/inputrc_append.conf"
# end

# SSH host keys
write_host_key(:path => '/etc/ssh/ssh_host_rsa_key', :content => node['ssh_host_rsa_key_private'], :mode => 0600)
write_host_key(:path => '/etc/ssh/ssh_host_rsa_key.pub', :content => node['ssh_host_rsa_key_public'], :mode => 0644)
