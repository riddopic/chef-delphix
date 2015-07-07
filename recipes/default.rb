# encoding: UTF-8
#
# Author:    Stefano Harding <riddopic@gmail.com>
# License:   Apache License, Version 2.0
# Copyright: (C) 2014-2015 Stefano Harding
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

if platform_family? 'debian'
  include_recipe 'apt::default'
end

node.default['build-essential']['compile_time'] = true
include_recipe 'build-essential::default'

gem_version = node[:delphix][:gem][:version]

if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
  chef_gem 'delphix' do
    version gem_version
    compile_time true
  end
else
  chef_gem 'delphix' do
    version gem_version
    action :nothing
  end.run_action(:install)
end

require 'delphix'