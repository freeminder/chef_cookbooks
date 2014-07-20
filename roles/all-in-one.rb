name "all-in-one"
description "Configures application and database components"
run_list(
  "role[base]",
  "recipe[app::user_deploy]",
  "recipe[rvm::system]",
  "recipe[nginx::source]",
  "recipe[monit::nginx]",
  "recipe[app::default]",
  'recipe[percona::all-in-one]',
  "recipe[monit::percona]",
  'recipe[redisio::all-in-one]',
  "recipe[monit::redis]"
)

default_attributes(
  "percona" => {
    "server" => {
      "role" => "cluster"
    },

    "cluster" => {
      "package"                     => "percona-xtradb-cluster-56",
      "wsrep_cluster_name"          => "xps_swapslider",
      "wsrep_sst_receive_interface" => "eth0" # can be eth0, public, private, etc.
    }
  }
)

