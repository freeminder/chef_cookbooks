# configuration file
template "/etc/monit/conf.d/twemproxy.monitrc" do
  owner  "root"
  group  "root"
  mode   "0644"
  source "twemproxy.monitrc.erb"
  notifies :reload, "service[monit]", :delayed
end
