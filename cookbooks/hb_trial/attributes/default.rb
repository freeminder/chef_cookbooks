# node.default['cdn']['vhosts'] = Chef::DataBagItem.load('configs', 'vhosts')["common_names"]

# MAPPING: WHICH VHOST GOES TO WHICH GROUP

node.default['cdn']['vhosts'] = [
  {  "vhost" => "web1.example.com", "port" => "8081"  },
  {  "vhost" => "web2.example.com", "port" => "8082"  },
  {  "vhost" => "web3.example.com", "port" => "8081"  }
]
