name "database"
description "Configures database components and replication between servers"
run_list(
  "role[base]",
  "recipe[database::default]"
)
