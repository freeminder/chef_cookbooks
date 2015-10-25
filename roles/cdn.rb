name "cdn"
description "Install and configure a server for CDN"
run_list(
  "recipe[apt::default]",
  "recipe[unattended-upgrades::default]",
  "recipe[misc::noiptables]",
  "recipe[hb_trial::user_deploy]",
  "recipe[nginx::default]",
  "recipe[hb_trial::nginx]"
)
