case node['platform_family']
when 'debian'
	apt_package 'libmysqlclient-dev'
	apt_package 'htop'
when 'rhel', 'fedora'
	yum_package 'mysql-devel'
end


# INSTALL AND DEFINE SERVICES
package 'nginx'

# NGINX CONFIG
template '/etc/nginx/nginx.conf' do
	 mode '0644'
	 owner 'root'
	 group 'root'
	 notifies :reload, 'service[nginx]'
end
