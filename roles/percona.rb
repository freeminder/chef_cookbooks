name "percona"
description "Percona XtraDB Cluster"

run_list(
  "role[base]",
  'recipe[percona::percona]',
  "recipe[monit::percona]"
)

default_attributes(
  "percona" => {
    "server" => {
      "role" => "cluster"
    },

    "cluster" => {
      "package"                     => "percona-xtradb-cluster-56",
      "wsrep_cluster_name"          => "xps_swapslider",
      "wsrep_cluster_address"       => "gcomm://54.164.38.176,192.99.47.158,54.183.196.128",
      "wsrep_sst_receive_interface" => "eth0" # can be eth0, public, private, etc.
    }
  }
)
