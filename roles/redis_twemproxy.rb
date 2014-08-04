name "redis_twemproxy"
description "Redis with twemproxy"

run_list(
	"role[base]",
	"recipe[app::user_deploy]",
	"recipe[rvm::system]",
	'recipe[redisio::all-in-one]',
	'recipe[twemproxy::default]'
)

default_attributes(
		# ...
		:twemproxy => {
				:config => {
						# This is the name of a section in the twemproxy YAML file.
						:alpha => {
								# These are the lines of configuration written out.
								:config => [
										"listen: 127.0.0.1:22121",
										"hash: fnv1a_64",
										"distribution: ketama",
										"timeout: 400",
										"backlog: 1024",
										"preconnect: true",
										"redis: true",
										# ...
										"servers:",
										" - 172.31.38.177:6379:1 server1",
										" - 172.31.47.1:6379:1 server2",
										" - 172.31.42.198:6379:1 server3",
								],
						},
						:beta => {
								# These are the lines of configuration written out.
								:config => [
										"listen: 127.0.0.1:22122",
										"hash: fnv1a_64",
										"distribution: ketama",
										"timeout: 400",
										"backlog: 1024",
										"preconnect: true",
										"redis: true",
										# ...
										"servers:",
										" - 172.31.38.177:6380:1 server4",
										" - 172.31.47.1:6380:1 server5",
										" - 172.31.42.198:6380:1 server6",
								],
						},
				},
		},
)

