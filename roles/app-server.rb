name "app-server"
description "Install and configure application server"
run_list(
  "role[base]",
  "recipe[app::user_deploy]",
  "recipe[rvm::system]",
  "recipe[nginx::source]",
  "recipe[app::default]"
)
