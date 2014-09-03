# -----------------------------------------------------------------------------
# PVLB Configuration
# Please edit starting here
# note that you can also override this within your server role parameters
# if you prefer
# -----------------------------------------------------------------------------

# LIST OF SERVER NAME TO IP ADDRESS MAPPINGS + WEIGHT (RELATIVE POWER)
node.default['pvlb']['lb_servers'] = {
  'all-in-one-04' => {
    'ipaddr' => '54.164.38.176',
    'weight' => 100,
  },
  'all-in-one-05' => {
    'ipaddr' => '192.99.47.158',
    'weight' => 90,
  },
  'all-in-one-06' => {
    'ipaddr' => '54.183.196.128',
    'weight' => 1,
  },
  'all-in-one-07' => {
    'ipaddr' => '192.99.38.175',
    'weight' => 90,
  },
}

# LIST OF SERVER GROUPS
node.default['pvlb']['lb_groups'] = {
  'dev.swapslider.com' => [
    'all-in-one-04',
    'all-in-one-05',
    'all-in-one-06',
    'all-in-one-07'
  ],
  # 'site2' => [
  #   'web1site1',
  #   'web2site2'
  # ],
}

# MAPPING: WHICH VHOST GOES TO WHICH GROUP
node.default['pvlb']['lb_vhosts'] = {
  'dev.swapslider.com' => [
    'swapslider.com',
    'www.swapslider.com',
    'dev.swapslider.com'
  ],
  # 'site2' => [
  #   'secondsite.com',
  #   'www.secondsite.com',
  # ],
}

node.default['pvlb']['statsusr'] = 'admin'
node.default['pvlb']['statspwd'] = 'supersecure'
node.default['pvlb']['haproxy_extra_raw_config'] = ''


# -----------------------------------------------------------------------------
# Editing of configuration ends here
# Please don't touch to anything beyond here unless you know exactly what
# you are doing
# -----------------------------------------------------------------------------

# # We assume that the ports from 12000 onwards are open
# node.default['pvlb']['starting_port'] = 12000
# current_port = node['pvlb']['starting_port']

# node.default['pvlb']['lb_name_to_port'] = {}

# node['pvlb']['lb_vhosts'].each do |name,vhosts|
#   # first port is for stats (since we do +1 immediately)
#   current_port += 1
#   node.default['pvlb']['lb_name_to_port'][name] = current_port
# end

# # Compute md5 hash for each server (for serverid)
# # Why? Because it's a bit safer, it hides a bit of your infrastructure
# require 'digest/md5'
# node['pvlb']['lb_servers'].keys.each do |servername|
#   node.default['pvlb']['lb_servers'][servername]['hexdigest'] =
#     Digest::MD5.hexdigest(servername)
# end

# Now we will have:
# NGINX->Vhost name->Local port->HAPROXY->servers
# Through an NGINX config that maps names to port
# and an HAPROXY config that maps port to servers

