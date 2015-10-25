require 'chef/provisioning/aws_driver'

with_driver 'aws::eu-central-1'


aws_vpc 'ref-vpc' do
  action :purge
end

aws_dhcp_options 'ref-dhcp-options' do
  domain_name          'example.com'
  domain_name_servers  %w(8.8.8.8 8.8.4.4)
  ntp_servers          %w(8.8.8.8 8.8.4.4)
  netbios_name_servers %w(8.8.8.8 8.8.4.4)
  netbios_node_type    2
  aws_tags :chef_type => "aws_dhcp_options"
end

aws_vpc 'ref-vpc' do
  cidr_block '10.0.0.0/24'
  internet_gateway true
  instance_tenancy :default
  main_routes '0.0.0.0/0' => :internet_gateway
  dhcp_options 'ref-dhcp-options'
  enable_dns_support true
  enable_dns_hostnames true
  aws_tags :chef_type => "aws_vpc"
end

aws_route_table 'ref-main-route-table' do
  action :purge
end
aws_route_table 'ref-main-route-table' do
  vpc 'ref-vpc'
  routes '0.0.0.0/0' => :internet_gateway
  aws_tags :chef_type => "aws_route_table"
end

aws_vpc 'ref-vpc' do
  main_route_table 'ref-main-route-table'
end

aws_security_group 'ref-sg1' do
  vpc 'ref-vpc'
  inbound_rules '0.0.0.0/0' => [ 22, 80, 443 ]
  outbound_rules [
    {:port => 1..65535, :protocol => :tcp,  :destinations => ['0.0.0.0/0'] },
    {:port => 1..65535, :protocol => :udp,  :destinations => ['0.0.0.0/0'] }
  ]
  aws_tags :chef_type => "aws_security_group"
end

aws_route_table 'ref-public' do
  action :purge
end
aws_route_table 'ref-public' do
  vpc 'ref-vpc'
  routes '0.0.0.0/0' => :internet_gateway
  aws_tags :chef_type => "aws_route_table"
end

aws_network_acl 'ref-acl' do
  vpc 'ref-vpc'
  inbound_rules(
    [
      { rule_number: 100, action: :allow, protocol: -1, cidr_block: '0.0.0.0/0' },
      { rule_number: 200, action: :allow, protocol: 6, port_range: 443..443, cidr_block: '172.31.0.0/24' }
    ]
  )
  outbound_rules(
    [
      { rule_number: 100, action: :allow, protocol: -1, cidr_block: '0.0.0.0/0' }
    ]
  )
end

aws_subnet 'ref-subnet' do
  vpc 'ref-vpc'
  cidr_block '10.0.0.0/24'
  availability_zone 'eu-central-1a'
  map_public_ip_on_launch true
  route_table 'ref-public'
  aws_tags :chef_type => "aws_subnet"
  network_acl 'ref-acl'
end

machine_batch do
  machine 'nginx-cache1' do
    role 'cdn'
    machine_options bootstrap_options: {
      image_id: "ami-accff2b1", # default for eu-central-1
      instance_type: "t2.micro",
      subnet_id: 'ref-subnet',
      security_group_ids: 'ref-sg1',
      availability_zone: 'eu-central-1a',
      key_name: "id_rsa" # If not specified, this will be used and generated
    },
    transport_address_location: :public_ip # `:public_ip` (default), `:private_ip` or `:dns`.  Defines how SSH or WinRM should find an address to communicate with the instance.
  end
  machine 'nginx-cache2' do
    role 'cdn'
    machine_options bootstrap_options: {
      image_id: "ami-accff2b1", # default for eu-central-1
      instance_type: "t2.micro",
      subnet_id: 'ref-subnet',
      security_group_ids: 'ref-sg1',
      availability_zone: 'eu-central-1a',
      key_name: "id_rsa" # If not specified, this will be used and generated
    },
    transport_address_location: :public_ip # `:public_ip` (default), `:private_ip` or `:dns`.  Defines how SSH or WinRM should find an address to communicate with the instance.
  end
  machine 'mysql' do
    role 'mysql'
    machine_options bootstrap_options: {
      image_id: "ami-accff2b1", # default for eu-central-1
      instance_type: "t2.micro",
      subnet_id: 'ref-subnet',
      # private_ip_address: "10.0.0.10",
      security_group_ids: 'ref-sg1',
      availability_zone: 'eu-central-1a',
      key_name: "id_rsa" # If not specified, this will be used and generated
    },
    transport_address_location: :public_ip # `:public_ip` (default), `:private_ip` or `:dns`.  Defines how SSH or WinRM should find an address to communicate with the instance.
  end
end


load_balancer 'ref-load-balancer' do
  machines [ 'nginx-cache1', 'nginx-cache2' ]
  load_balancer_options(
    lazy do
      {
        listeners: [{
          port: 80,
          protocol: :http,
          instance_port: 80,
          instance_protocol: :http
        }],
        health_check: {
          healthy_threshold:    2,
          unhealthy_threshold:  4,
          interval:             12,
          timeout:              5,
          target:               "HTTP:80/"
        },
        subnets: 'ref-subnet',
        security_groups: 'ref-sg1'
     }
    end
  )
end


# Doesn't work. Read https://github.com/chef/chef-provisioning-aws/issues/366
# aws_eip_address 'ref-elastic-ip' do
#   machine 'ref-nat' do
#     machine_options bootstrap_options: {
#       image_id: "ami-1e073a03",
#       instance_type: "t2.micro",
#       subnet_id: 'ref-subnet',
#       security_group_ids: 'ref-sg1',
#       availability_zone: 'eu-central-1a',
#       key_name: "id_rsa"
#     },
#     transport_address_location: :public_ip
#   end
#   associate_to_vpc true
# end

