#
# Cookbook Name:: percona
# Recipe:: configure_server
#

percona = node["percona"]
server  = percona["server"]
conf    = percona["conf"]
mysqld  = (conf && conf["mysqld"]) || {}

# construct an encrypted passwords helper -- giving it the node and bag name
passwords = EncryptedPasswords.new(node, percona["encrypted_data_bag"])

wsrep_sst_auth = "backup:#{passwords.backup_password}"
node.override["percona"]["cluster"]["wsrep_sst_auth"] = wsrep_sst_auth

template "/root/.my.cnf" do
  variables(root_password: passwords.root_password)
  owner "root"
  group "root"
  mode "0600"
  source "my.cnf.root.erb"
  not_if { node["percona"]["skip_passwords"] }
end

if server["bind_to"]
  ipaddr = Percona::ConfigHelper.bind_to(node, server["bind_to"])
  if ipaddr && server["bind_address"] != ipaddr
    node.override["percona"]["server"]["bind_address"] = ipaddr
    node.save unless Chef::Config[:solo]
  end

  log "Can't find ip address for #{server["bind_to"]}" do
    level :warn
    only_if { ipaddr.nil? }
  end
end

datadir = mysqld["datadir"] || server["datadir"]
logdir  = mysqld["logdir"] || server["logdir"]
tmpdir  = mysqld["tmpdir"] || server["tmpdir"]
user    = mysqld["username"] || server["username"]

# this is where we dump sql templates for replication, etc.
directory "/etc/mysql" do
  owner "root"
  group "root"
  mode "0755"
end

# setup the data directory
directory datadir do
  owner user
  group user
  recursive true
end

# setup the log directory
directory logdir do
  owner user
  group user
  recursive true
end

# setup the tmp directory
directory tmpdir do
  owner user
  group user
  recursive true
end

# define the service
service "mysql" do
  supports restart: true
  action server["enable"] ? :enable : :disable
end

# install db to the data directory
execute "setup mysql datadir" do
  command "mysql_install_db --user=#{user} --datadir=#{datadir}"
  not_if "test -f #{datadir}/mysql/user.frm"
end


# setup ssl
%w{ ca.pem  cert.pem  client-cert.pem  client-key-enc.pem  client-key.pem  key.pem  server-cert.pem  server-key-enc.pem  server-key.pem }.each do |file|
  cookbook_file "/etc/mysql/#{file}" do
    mode '0640'
    owner 'root'
    group 'mysql'
  end
end


# setup the main server config file
template percona["main_config_file"] do
  source "my.cnf.#{conf ? "custom" : server["role"]}.erb"
  owner "root"
  group "root"
  mode "0644"

  if node["percona"]["auto_restart"]
    notifies :restart, "service[mysql]", :immediately
  end
end

# now let's set the root password only if this is the initial install
unless node["percona"]["skip_passwords"]
  execute "Update MySQL root password" do
    root_pw = passwords.root_password
    command "mysqladmin --user=root --password='' password '#{root_pw}'"
    not_if "test -f /etc/mysql/grants.sql"
  end
end

# setup the debian system user config
template "/etc/mysql/debian.cnf" do
  source "debian.cnf.erb"
  variables(debian_password: passwords.debian_password)
  owner "root"
  group "root"
  mode "0640"
  if node["percona"]["auto_restart"]
    notifies :restart, "service[mysql]", :immediately
  end
  only_if { platform_family?("debian") }
end

# remove default configuration
file "/etc/mysql/my.cnf" do
  action :delete
  if node["percona"]["auto_restart"]
    notifies :restart, "service[mysql]", :immediately
  end
end
