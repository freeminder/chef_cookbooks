# INSTALL PACKAGES
package 'mc'
package 'curl'
package 'git'


# PATCH /etc/inputrc
cookbook_file '/etc/inputrc' do
	 mode '0644'
	 owner 'root'
	 group 'root'
end


# SSH keys
directory '/root/.ssh' do
	mode '0700'
	owner 'root'
	group 'root'
end

cookbook_file '/root/.ssh/id_rsa' do
	 mode '0400'
	 owner 'root'
	 group 'root'
	 source 'slider_rsa'
end

cookbook_file '/root/.ssh/id_rsa.pub' do
	 mode '0644'
	 owner 'root'
	 group 'root'
	 source 'slider_rsa.pub'
end


# Create a user
user "chef" do
  comment "Chef User"
  gid "users"
  home "/home/chef"
  shell "/bin/bash"
  password "$1$zXNyUjfV$JU.t4NkqTaZfrMFKuhImU0"
  supports manage_home: true
end




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
