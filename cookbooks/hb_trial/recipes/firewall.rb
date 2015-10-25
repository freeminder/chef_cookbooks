node_ips = []
unless Chef::Config[:solo]
	search(:node, 'role:all-in-one').each do |other_node|
		# next if other_node['ipaddress'] == node['ipaddress']
		Chef::Log.info "Found other node: #{other_node['ipaddress']}"
		node_ips << other_node['ipaddress']
	end
end


# Save iptables-rules
execute "cp /etc/iptables-rules /etc/iptables-rules.bak-`date +%Y%m%d_%H:%M:%S`" do
  not_if { File.exist?("/etc/iptables-rules") }
end


# ipset
cookbook_file "/etc/ipset" do
	source "ipset"
	mode '0644'
	owner 'root'
	group 'root'
end

# node_ips.each do |ip|
# 		ruby_block "insert_line" do
# 			block do
# 				file = Chef::Util::FileEdit.new("/etc/ipset")
# 				file.insert_line_if_no_match("add servers #{ip}", "add servers #{ip}")
# 				file.write_file
# 			end
# 	end
# end

execute "Import ipset list" do
	user "root"
	command "ipset restore < /etc/ipset"
	only_if { File.exist?("/etc/ipset") }
end


# Allow access from other nodes
simple_iptables_rule "Allow_servers" do
	rule [ "-m set --match-set servers src" ]
	jump "ACCEPT"
end

# Allow access from admins
simple_iptables_rule "Allow_admins" do
	rule [ "-p tcp -m set --match-set admins src -m multiport --dports 2812,22222" ]
	jump "ACCEPT"
end

execute "reload-iptables" do
	command "iptables-restore < /etc/iptables-rules"
	user "root"
	only_if { File.exist?("/etc/ipset") }
end

