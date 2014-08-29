# configuration file
template "/etc/monit/conf.d/sentinel.monitrc" do
  owner  "root"
  group  "root"
  mode   "0644"
  source "sentinel.monitrc.erb"
  notifies :reload, "service[monit]", :delayed
end
