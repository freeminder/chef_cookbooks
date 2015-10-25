require 'chef/provisioning/aws_driver'

with_driver 'aws::eu-central-1'

#
# This recipe sets every single value of every single object
#

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

# aws_key_pair 'ref-key-pair' do
#   private_key_options({
#     :format => :pem,
#     :type => :rsa,
#     :regenerate_if_different => true
#   })
#   allow_overwrite true
# end

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

# # We cover tagging the base chef-provisioning resources in aws_tags.rb
# machine_image 'ref-mysql-at-private-subnet' do
#   image_options description: 'some image description'
# end

# # machine_image 'ref-machine_image2' do
# #   from_image 'ref-mysql-at-private-subnet'
# # end

# machine_image 'ref-machine_image3' do
#   machine_options bootstrap_options: {
#     # for some reason, sshing into this host takes 20+ seconds with these enabled
#     subnet_id: 'ref-subnet',
#     security_group_ids: 'ref-sg1',
#     image_id: 'ref-mysql-at-private-subnet',
#     instance_type: 't2.small'
#   }
# end

# with_machine_options({
#   # See https://github.com/chef/chef-provisioning#machine-options for options shared between drivers
#   bootstrap_options: {
#     # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Resource.html#create_instances-instance_method
#     # lists the available options.  The below options are the default
#     image_id: "ami-accff2b1", # default for eu-central-1
#     instance_type: "t2.micro",
#     availability_zone: 'eu-central-1a',
#     key_name: "id_rsa", # If not specified, this will be used and generated
#     # key_path: "~/.chef/keys/chef_default", # only necessary if storing keys some other location
#   },
#   transport_address_location: :private_ip, # `:public_ip` (default), `:private_ip` or `:dns`.  Defines how SSH or WinRM should find an address to communicate with the instance.
# })

machine 'nginx-cache' do
  role 'cdn'
  machine_options bootstrap_options: {
    image_id: "ami-accff2b1", # default for eu-central-1
    instance_type: "t2.micro",
    # subnet_id: 'ref-subnet',
    # security_group_ids: 'ref-sg1',
    availability_zone: 'eu-central-1a',
    key_name: "id_rsa" # If not specified, this will be used and generated
  },
  transport_address_location: :public_ip # `:public_ip` (default), `:private_ip` or `:dns`.  Defines how SSH or WinRM should find an address to communicate with the instance.
end

machine 'mysql-at-private-subnet' do
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


# machine_batch do
#   machine 'ref-machine1' do
#     machine_options bootstrap_options: { image_id: 'ref-mysql-at-private-subnet', :availability_zone => 'eu-central-1a', instance_type: 'm3.medium' }
#     ohai_hints 'ec2' => { 'a' => 'b' }
#     converge false
#   end
#   machine 'ref-machine2' do
#     from_image 'ref-mysql-at-private-subnet'
#     machine_options bootstrap_options: {
#       key_name: 'ref-key-pair',
#       #subnet_id: 'ref-subnet',
#       #security_group_ids: 'ref-sg1'
#     }
#   end
# end

load_balancer 'ref-load-balancer' do
  machines [ 'nginx-cache' ]
  load_balancer_options(
    attributes: {
      cross_zone_load_balancing: {
        enabled: true
      }
    }
  )
end

# aws_launch_configuration 'ref-launch-configuration' do
#   image 'ref-mysql-at-private-subnet'
#   instance_type 't1.micro'
#   options security_groups: 'ref-sg1'
# end

# aws_auto_scaling_group 'ref-auto-scaling-group' do
#   availability_zones ['eu-central-1a']
#   desired_capacity 2
#   min_size 1
#   max_size 3
#   launch_configuration 'ref-launch-configuration'
#   load_balancers 'ref-load-balancer'
#   options subnets: 'ref-subnet'
# end

# aws_ebs_volume 'ref-volume' do
#   machine 'ref-machine1'
#   availability_zone 'a'
#   size 100
#   #snapshot
#   iops 3000
#   volume_type 'io1'
#   encrypted true
#   device '/dev/sda2'
#   aws_tags :chef_type => "aws_ebs_volume"
# end

# aws_eip_address 'ref-elastic-ip' do
#   machine 'ref-machine1'
#   associate_to_vpc true
#   # guh - every other AWSResourceWithEntry accepts tags EXCEPT this one
# end

# aws_s3_bucket 'ref-s3-bucket' do
#   enable_website_hosting true
#   options({ :acl => 'private' })
# end

# aws_sqs_queue 'ref-sqs-queue' do
#   options({ :delay_seconds => 1 })
# end

# aws_sns_topic 'ref-sns-topic' do
# end