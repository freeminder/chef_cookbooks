#
# Cookbook Name:: nginx
# Attribute:: passenger
#
# Author:: Alex Dergachev (<alex@evolvingweb.ca>)
#
# Copyright 2013, Opscode, Inc.
# Copyright 2012, Susan Potter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.default['nginx']['passenger']['version'] = '4.0.45'
node.default['nginx']['passenger']['root'] = "/usr/local/rvm/gems/ruby-2.1.2/gems/passenger-#{node['nginx']['passenger']['version']}"
node.default['nginx']['passenger']['ruby'] = '/usr/local/rvm/gems/ruby-2.1.2/wrappers/ruby'
node.default['nginx']['passenger']['gem_home'] = '/usr/local/rvm/gems/ruby-2.1.2'
node.default['nginx']['passenger']['gem_binary'] = '/usr/local/rvm/rubies/ruby-2.1.2/bin/gem'

# if node['languages'].attribute?('ruby')
#   node.default['nginx']['passenger']['root'] = "#{node['languages']['ruby']['gems_dir']}/gems/passenger-#{node['nginx']['passenger']['version']}"
#   node.default['nginx']['passenger']['ruby'] = node['languages']['ruby']['ruby_bin']
#   node.default['nginx']['passenger']['root'] = "#{node['languages']['ruby']['gems_dir']}/gems/passenger-#{node['nginx']['passenger']['version']}"
#   node.default['nginx']['passenger']['ruby'] = node['languages']['ruby']['ruby_bin']
# else
#   Chef::Log.warn("node['languages']['ruby'] attribute not detected in #{cookbook_name}::#{recipe_name}")
#   Chef::Log.warn("Install a Ruby for automatic detection of node['nginx']['passenger'] attributes (root, ruby)")
#   Chef::Log.warn('Using default values that may or may not work for this system.')
#   node.default['nginx']['passenger']['root'] = "/usr/local/rvm/gems/ruby-2.1.2/gems/passenger-#{node['nginx']['passenger']['version']}"
#   node.default['nginx']['passenger']['ruby'] = '/usr/local/rvm/gems/ruby-2.1.2/wrappers/ruby'
# end

# node.default['nginx']['passenger']['packages']['rhel'] = %w(ruby-devel curl-devel)
# node.default['nginx']['passenger']['packages']['debian'] = %w(ruby-dev libcurl4-gnutls-dev)
node.default['nginx']['passenger']['packages']['rhel'] = %w(curl-devel)
node.default['nginx']['passenger']['packages']['debian'] = %w(libcurl4-gnutls-dev)

node.default['nginx']['passenger']['spawn_method'] = 'smart-lv2'
node.default['nginx']['passenger']['buffer_response'] = 'on'
node.default['nginx']['passenger']['max_pool_size'] = 500
node.default['nginx']['passenger']['min_instances'] = 200
node.default['nginx']['passenger']['max_instances_per_app'] = 0
node.default['nginx']['passenger']['pool_idle_time'] = 150
node.default['nginx']['passenger']['max_requests'] = 0
# node.default['nginx']['passenger']['gem_binary'] = nil
