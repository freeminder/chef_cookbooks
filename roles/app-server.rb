name "app-server"
description "install and configure application server"
run_list(
  "role[base]",
  "recipe[app-misc::default]"
)
