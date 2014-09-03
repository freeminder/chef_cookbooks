name "redis_twemproxy"
description "Redis with twemproxy"

run_list(
	# "role[base]",
	# "recipe[app::user_deploy]",
	# "recipe[rvm::system]",
	# 'recipe[redisio::all-in-one]',
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
										" - 54.164.38.176:7001:1 server1",
										" - 54.164.38.176:7002:1 server2",
										" - 54.164.38.176:7003:1 server3",
										" - 54.164.38.176:7004:1 server4",
										" - 54.164.38.176:7005:1 server5",
										" - 54.164.38.176:7006:1 server6",
										" - 54.164.38.176:7007:1 server7",
										" - 54.164.38.176:7008:1 server8",
										" - 54.164.38.176:7009:1 server9",
										" - 54.164.38.176:7010:1 server10",
										" - 54.164.38.176:7011:1 server11",
										" - 54.164.38.176:7012:1 server12",
										" - 54.164.38.176:7013:1 server13",
										" - 54.164.38.176:7014:1 server14",
										" - 54.164.38.176:7015:1 server15",
										" - 54.164.38.176:7016:1 server16",
										" - 54.164.38.176:7017:1 server17",
										" - 54.164.38.176:7018:1 server18",
										" - 54.164.38.176:7019:1 server19",
										" - 54.164.38.176:7020:1 server20",
										" - 54.164.38.176:7021:1 server21",
										" - 54.164.38.176:7022:1 server22",
										" - 54.164.38.176:7023:1 server23",
										" - 54.164.38.176:7024:1 server24",
										" - 54.164.38.176:7025:1 server25",
										" - 54.164.38.176:7026:1 server26",
										" - 54.164.38.176:7027:1 server27",
										" - 54.164.38.176:7028:1 server28",
										" - 54.164.38.176:7029:1 server29",
										" - 54.164.38.176:7030:1 server30",
										" - 54.164.38.176:7031:1 server31",
										" - 54.164.38.176:7032:1 server32",
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
										" - 192.99.47.158:7001:1 server101",
										" - 192.99.47.158:7002:1 server102",
										" - 192.99.47.158:7003:1 server103",
										" - 192.99.47.158:7004:1 server104",
										" - 192.99.47.158:7005:1 server105",
										" - 192.99.47.158:7006:1 server106",
										" - 192.99.47.158:7007:1 server107",
										" - 192.99.47.158:7008:1 server108",
										" - 192.99.47.158:7009:1 server109",
										" - 192.99.47.158:7010:1 server110",
										" - 192.99.47.158:7011:1 server111",
										" - 192.99.47.158:7012:1 server112",
										" - 192.99.47.158:7013:1 server113",
										" - 192.99.47.158:7014:1 server114",
										" - 192.99.47.158:7015:1 server115",
										" - 192.99.47.158:7016:1 server116",
										" - 192.99.47.158:7017:1 server117",
										" - 192.99.47.158:7018:1 server118",
										" - 192.99.47.158:7019:1 server119",
										" - 192.99.47.158:7020:1 server120",
										" - 192.99.47.158:7021:1 server121",
										" - 192.99.47.158:7022:1 server122",
										" - 192.99.47.158:7023:1 server123",
										" - 192.99.47.158:7024:1 server124",
										" - 192.99.47.158:7025:1 server125",
										" - 192.99.47.158:7026:1 server126",
										" - 192.99.47.158:7027:1 server127",
										" - 192.99.47.158:7028:1 server128",
										" - 192.99.47.158:7029:1 server129",
										" - 192.99.47.158:7030:1 server130",
										" - 192.99.47.158:7031:1 server131",
										" - 192.99.47.158:7032:1 server132",
								],
						},
				},
		},
)

