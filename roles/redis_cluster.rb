name "redis_cluster"
description "Redis Cluster"

run_list(
  "role[base]",
  "recipe[app::user_deploy]",
  "recipe[rvm::system]",
  'recipe[redisio::cluster]'
)
