name "app-server"
description "Install and configure application server"
run_list(
  "role[base]",
  "recipe[rvm::system_install]",
  "recipe[nginx::source]",
  "recipe[app::default]"
)
