# Sentinel
execute "touch /var/log/sentinel.log; chown redis /var/log/sentinel.log" do
  not_if { File.exist?("/var/log/sentinel.log") }
end

template "sentinel" do
  path "/etc/init.d/sentinel"
  source "sentinel.init.erb"
  mode 0755
end

template "sentinel-conf" do
		path "/etc/redis/sentinel.conf"
    source "sentinel.conf.erb"
    mode 0666
    notifies :stop, "service[sentinel]"
    notifies :start, "service[sentinel]"
end

service "sentinel" do
    start_command "/etc/init.d/sentinel start"
    stop_command "/etc/init.d/sentinel stop"
    restart_command "/etc/init.d/sentinel stop && /etc/init.d/sentinel start"
    supports :start => true, :stop => true, :restart => true
    action [:start, :enable]
    subscribes :start, resources(:template => "sentinel-conf")
end

