name "load-balancer"
description "install and configure haproxy load balancer"
run_list(
  "role[base]",
  "recipe[haproxy::default]"
)
