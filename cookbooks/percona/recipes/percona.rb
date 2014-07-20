# Setup the Percona XtraDB Cluster
cluster_ips = []
unless Chef::Config[:solo]
  search(:node, 'role:percona').each do |other_node|
    next if other_node['ipaddress'] == node['ipaddress']
    Chef::Log.info "Found Percona XtraDB cluster peer: #{other_node['ipaddress']}"
    cluster_ips << other_node['ipaddress']
  end
  # cluster_ips.grep(/#{node.ipaddress}/) { |match| cluster_ips.delete(match) }
end


# Allow Percona group communication(4567), state transfer(4444), incremental state transfer(4568).
cluster_ips.each do |ip|
  simple_iptables_rule "Allow_#{ip}_to_DB" do
    rule [ "--proto tcp --dport 4567 -s #{ip}/32 -d #{node['ipaddress']}/32",
           "--proto tcp --dport 4568 -s #{ip}/32 -d #{node['ipaddress']}/32",
           "--proto tcp --dport 4444 -s #{ip}/32 -d #{node['ipaddress']}/32" ]
    jump "ACCEPT"
  end
end


cluster_address = "gcomm://#{cluster_ips.join(',')}"
Chef::Log.info "Using Percona XtraDB cluster address of: #{cluster_address}"
node.override["percona"]["cluster"]["wsrep_cluster_address"] = cluster_address
node.override["percona"]["cluster"]["wsrep_node_name"] = node['hostname']


include_recipe 'percona::cluster'
include_recipe 'percona::backup'
include_recipe 'percona::toolkit'

