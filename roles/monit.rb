name "monit"
description "Install and configure monitoring"
run_list(
  "role[base]",
  "recipe[monit::default]"
)
