name "app-server"
description "Install and configure application server"
run_list(
  "role[base]",
  "recipe[app::default]"
)
