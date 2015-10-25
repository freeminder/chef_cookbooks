name "mysql"
description "Install and configure MySQL for a DB server"
run_list(
  "recipe[apt::default]",
  "recipe[unattended-upgrades::default]",
  "recipe[misc::noiptables]",
  "recipe[hb_trial::mysql]"
)
