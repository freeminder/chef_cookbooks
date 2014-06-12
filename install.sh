#!/bin/bash -e

if [ "$UID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

# Only run it if we can (ie. on Ubuntu/Debian)
if [ -x /usr/bin/apt-get ]; then
	apt-get update
	apt-get -y upgrade
	apt-get -y install mc curl git
fi

# Only run it if we can (ie. on RHEL/CentOS)
if [ -x /usr/bin/yum ]; then
	rpm -Uvh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
	yum -y update
	yum -y install mc curl git
fi


# Setup ssh access and hostname
mkdir /root/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4/dloTDiMfF38k3TdK65403MKFyhu1PY1aoPs4ysU8ZWxMabBrKkrgqmAQSa52rh91JMrzG/YalAGtybQVl156GTiT8dmDVW8rIXjmEkmjmMCpYnjhSpe1csaHq/AELgQQ6gLlF4Nfl4P+EkZF6NYV6AquvJmUpJPPEY4dd4U6IPX1zsDVZE5SSj4ryiAiNKzf6r61BcOp3ltVtPfBImESsfkKoZ1l7YBgX2hkSIMhD967aeMf8bNJ7o1+QjYFVTY0bM3nGrQl7vjh9WCc27L0LNCEkgKggJJYTEv/CDAJkZpCT0nx2U8K97yBA5CofFGNmg6E6zgd4LtJep3O5Un dim@e46' >> /root/.ssh/authorized_keys
echo `ip ad sh|grep -a0 "eth"|grep "inet "|awk '{ print $2 }'|cut -d / -f 1` chef-server.local chef-server >> /etc/hosts
echo "" >> /etc/hosts
echo 'chef-server.local' > /etc/hostname
hostname -F /etc/hostname


# Install chef-client on Ubuntu/Debian or RHEL/CentOS
if [ ! -x /usr/bin/chef-solo ] && [ ! -x /opt/chef/embedded/bin/chef-solo ] && [ $1 == client ]
then
	curl -L https://www.opscode.com/chef/install.sh | bash

	curl -L https://get.rvm.io | bash -s stable --ruby --autolibs=enable --auto-dotfiles
	source /usr/local/rvm/scripts/rvm
	echo "source /usr/local/rvm/scripts/rvm" >> .bashrc
	gem install chef
fi

# Install chef-server on Ubuntu/Debian or RHEL/CentOS
if [ ! -x /usr/bin/chef-solo ] && [ ! -x /opt/chef/embedded/bin/chef-solo ] && [ $1 == server ]
then
	if [ -x /usr/bin/apt-get ]; then
		#!!#curl -L https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.1.1-1_amd64.deb && \
		dpkg -i chef-server_11.1.1-1_amd64.deb \
		&& rm -f chef-server_11.1.1-1_amd64.deb
		chef-server-ctl reconfigure

		#!!#curl -L https://www.opscode.com/chef/install.sh | bash

		curl -L https://get.rvm.io | bash -s stable --ruby --autolibs=enable --auto-dotfiles
		source /usr/local/rvm/scripts/rvm
		echo "source /usr/local/rvm/scripts/rvm" >> .bashrc
		gem install chef
	fi

	if [ -x /usr/bin/yum ]; then
		#!!# rpm -Uvh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-server-11.1.1-1.el6.x86_64.rpm
		rpm -i /root/chef-server-11*.rpm \
		&& rm -f /root/chef-server-11*.rpm
		chef-server-ctl reconfigure
		iptables -I INPUT -p tcp --dport 443 -d `ip ad sh|grep -a0 "eth"|grep "inet "|awk '{ print $2 }'|cut -d / -f 1` -j ACCEPT

		#!!#curl -L https://www.opscode.com/chef/install.sh | bash

		curl -L https://get.rvm.io | bash -s stable --ruby --autolibs=enable --auto-dotfiles
		source /usr/local/rvm/scripts/rvm
		echo "source /usr/local/rvm/scripts/rvm" >> .bashrc
		gem install chef
	fi
fi



mkdir -p /etc/chef /etc/chef/src
git clone git@bitbucket.org:waynestjohn/swapslidercookbooks.git /etc/chef/src/
cp /etc/chef/src/config/solo.rb /etc/chef/solo.rb

chef-solo -o role[base]
