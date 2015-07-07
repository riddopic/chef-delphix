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

require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'kitchen/rake_tasks'
require 'foodcritic'
require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files = %w[**/*.rb - README.md LICENSE]
  t.stats_options = %w[--list-undoc]
end

namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby) do |t|
    t.options = %w[--display-cop-names --display-style-guide]
  end

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      search_gems:   true,
      tags:        ['~FC001'],
      fail_tags:   ['any'],
      chef_version: '11.6.0',
      include:      'test/support/foodcritic/*'
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-c -f d'
  t.pattern    = %w[test/unit/**/*_spec.rb]
end

namespace :integration do
  desc 'Run Test Kitchen with Docker'
  task :docker do
    Kitchen.logger = Kitchen.default_file_logger
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end

  desc 'Run Test Kitchen Concurrently for all instances'
  task :concurrent do
    Kitchen.logger = Kitchen.default_file_logger
    @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.yml')
    config = Kitchen::Config.new(loader: @loader)
    concurrency = config.instances.size
    queue = Queue.new
    config.instances.each {|i| queue << i }
    concurrency.times { queue << nil }
    threads = []
    concurrency.times do
      threads << Thread.new do
        while instance = queue.pop
          instance.test(:always)
        end
      end
    end
    threads.map { |i| i.join }
  end
end

desc 'Run all tests on CI Platform'
task ci:      ['style', 'spec', 'integration:concurrent']

task default: ['style', 'spec', 'integration:docker']
