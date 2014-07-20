name "database"
description "Configures database components and replication between servers"
run_list(
  "role[base]",
  'recipe[percona::percona]',
  "recipe[monit::percona]",
  "recipe[app::user_deploy]",
  "recipe[rvm::system]",
  'recipe[redisio::cluster]',
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

