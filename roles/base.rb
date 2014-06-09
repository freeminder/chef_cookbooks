name "base"
description "Base role for a server"
run_list(
  "recipe[unattended-upgrades::default]"
)
default_attributes(
  node['unattended-upgrades']['email_address'] => "dmitry.zhukov@gmail.com"
)
