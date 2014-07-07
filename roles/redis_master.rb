name "redis_master"
description "Redis master node"

run_list(
  "role[base]",
  'recipe[redisio::master]'
)
