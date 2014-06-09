#!/bin/bash -e

if [ "$UID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Only run it if we can (ie. not on RH)
if [ -x /usr/bin/apt-get ]; then
  apt-get update
  apt-get -y upgrade
  apt-get -y install mc curl wget git
fi

# Only install chef if it's not there yet
if [ ! -x /usr/bin/chef-solo ] && [ ! -x /opt/chef/embedded/bin/chef-solo ]
#if [ ! -x /usr/bin/chef-solo ]
then
  curl -L https://www.opscode.com/chef/install.sh | bash
  curl -L https://get.rvm.io | bash -s stable --ruby --autolibs=enable --auto-dotfiles
  source /usr/local/rvm/scripts/rvm
  gem install chef
fi

mkdir -p /etc/chef /etc/chef/src
git git@bitbucket.org:free-minder/swapslidercookbooks.git /etc/chef/src/

cp solo.rb /etc/chef/solo.rb

#chef-solo -o pvlb
