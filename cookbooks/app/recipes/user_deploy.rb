# Create a user for deployments
user "deploy" do
  comment "User for deployment"
  gid "www-data"
  home "/home/deploy"
  shell "/bin/bash"
  password "$1$zXNyUjfV$JU.t4NkqTaZfrMFKuhImU0"
  supports manage_home: true
end

# SSH keys for deploy user
directory '/home/deploy/.ssh' do
	mode '0700'
	owner 'deploy'
	group 'www-data'
end

cookbook_file '/home/deploy/.ssh/id_rsa' do
	mode '0400'
	owner 'deploy'
	group 'www-data'
	source 'slider_rsa'
end

cookbook_file '/home/deploy/.ssh/id_rsa.pub' do
	mode '0644'
	owner 'deploy'
	group 'www-data'
	source 'slider_rsa.pub'
end

cookbook_file '/home/deploy/.ssh/authorized_keys' do
	mode '0600'
	owner 'deploy'
	group 'www-data'
end
