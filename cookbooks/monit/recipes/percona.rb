# configuration file
template "/etc/monit/conf.d/percona.monitrc" do
  owner  "root"
  group  "root"
  mode   "0644"
  source "percona.monitrc.erb"
  notifies :reload, "service[monit]", :delayed
end
