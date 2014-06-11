name "load-balancer"
description "Install and configure haproxy load balancer"
run_list(
  "role[base]",
  "recipe[haproxy::default]"
)
