name "redis_slave"
description "Redis slave node"

run_list(
  "role[base]",
  'recipe[redisio::slave]'
)
