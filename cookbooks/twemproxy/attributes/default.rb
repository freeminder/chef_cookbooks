#
# Cookbook Name:: twemproxy
# Attributes:: default
#
# Author:: Daniel Koepke (<daniel.koepke@kwarter.com>)
#
# Copyright 2013, Kwarter, Inc.
#

default[:twemproxy][:install_method] = "source"

default[:twemproxy][:version] = "0.3.0"
default[:twemproxy][:source_url] = "https://twemproxy.googlecode.com/files/nutcracker-#{default[:twemproxy][:version]}.tar.gz"
default[:twemproxy][:source_prefix] = "/opt"

default[:twemproxy][:package] = "nutcracker"
default[:twemproxy][:package_version] = nil

default[:twemproxy][:config_file] = "/etc/nutcracker.conf"

# This is a straightforward translation of the twemproxy YAML configuration into a Ruby hash.
default[:twemproxy][:config] = {}
