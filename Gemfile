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

source 'https://rubygems.org'

gem 'rest-client'

group :lint do
  gem 'foodcritic', '~> 4.0', '>= 4.0.0'
  gem 'rubocop', '~> 0.49', '>= 0.49.0'
end

group :unit do
  gem 'berkshelf', '~> 4', '>= 4.2.3'
  gem 'chefspec', '~> 4.4', '>= 4.4.0'
end

group :kitchen_common do
  gem 'test-kitchen'
  gem 'kitchen-sync'
end

group :kitchen_docker do
  gem 'kitchen-docker'
end

group :development do
  gem 'chef-zero'
  gem 'yard', '>= 0.9.20'
  gem 'yard-classmethods'
  gem 'guard'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rubocop'
  gem 'pry-nav'
end
