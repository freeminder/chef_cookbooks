# configuration file
template "/etc/monit/conf.d/redis.monitrc" do
  owner  "root"
  group  "root"
  mode   "0644"
  source "redis.monitrc.erb"
  notifies :reload, "service[monit]", :delayed
end
