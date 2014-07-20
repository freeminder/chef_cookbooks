name "base"
description "Base role for a server"
run_list(
  "recipe[unattended-upgrades::default]",
  "recipe[simple_iptables]",
  "recipe[misc::default]",
  "recipe[monit::default]"
)
# default_attributes(
#   default['unattended-upgrades']['email_address'] => "dmitry.zhukov@gmail.com"
# )
