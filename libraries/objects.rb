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

begin
  require 'delphix'
rescue LoadError
end

module Delphix
  #
  # Add the ability to load Delhpix Gem into the Chef::Recipe class.
  #
  module Objects
    #
    # Extract the reference to the item with the matching key.
    #
    # @param [String] item
    #   The name to item to search for.
    #
    # @param [Symbol] key
    #   The name to key to match with.
    #
    # @param [Array] list
    #   The list of items to search through.
    #
    # @return [Array]
    #   The reference to the item with the matching name.
    #
    def reference_to(item, key, list)
      list.reject { |i| i[key.to_sym] != item }.map { |i| i[:reference] }
    end

    # In-process cache LLT and LRU expiration semantics.
    #
    # @return [StashCache]
    #
    def cache
      @cache ||= Garcon::StashCache.new(ttl_seconds: 15, tti_seconds: 30)
    end

    # List database objects on the system.
    #
    # @return [Array]
    #
    def databases
      cache.fetch(:db) { Delphix.get(Delphix.database_url).body.result }
    end

    # Retrieve the reference to the specified database object.
    #
    # @param [String] name
    #   The name of the database to retrieve the reference from.
    #
    # @return [Array]
    #
    def db_ref(name)
      reference_to name, :name, databases
    end

    # List group objects on the system.
    #
    # @return [Array]
    #
    def db_groups
      cache.fetch(:group) { Delphix.get(Delphix.group_url).body.result }
    end

    # Retrieve the reference to the specified group object.
    #
    # @param [String] name
    #   The name of the group to retrieve the reference from.
    #
    # @return [Array]
    #
    def group_ref(name)
      reference_to name, :name, db_groups
    end

    # List environment objects on the system.
    #
    # @return [Array]
    #
    def environments
      cache.fetch(:env) { Delphix.get(Delphix.environment_url).body.result }
    end

    # Retrieve the reference to the specified environment object.
    #
    # @param [String] name
    #   The name of the environment to retrieve the reference from.
    #
    # @return [Array]
    #
    def env_ref(name)
      reference_to name, :name, environments
    end

    # List repositorie objects on the system.
    #
    # @return [Array]
    #
    def repositories
      cache.fetch(:repo) { Delphix.get(Delphix.repository_url).body.result }
    end

    # Retrieve the reference to the specified repositorie object.
    #
    # @param [String] name
    #   The name of the repositorie to retrieve the reference from.
    #
    # @return [Array]
    #
    def repo_ref(name)
      reference_to name, :environment, repositories
    end

    # List template objects on the system.
    #
    # @return [Array]
    #
    def templates
      url = "http://#{Delphix.server}/resources/json/delphix/database/template"
      cache.fetch(:template) { Delphix.get(url).body.result }
    end

    # Retrieve the reference to the specified template object.
    #
    # @param [String] name
    #   The name of the template to retrieve the reference from.
    #
    # @return [Array]
    #
    def template_ref(name)
      reference_to name, :name, templates
    end

    # List template objects on the system.
    #
    # @return [Array]
    #
    def js_templates
      url = "http://#{Delphix.server}/resources/json/delphix/jetstream/template"
      cache.fetch(:js_templates) { Delphix.get(url).body.result }
    end

    # Retrieve the reference to the specified jetstream/container object.
    #
    # @param [String] name
    #   The name of the jetstream/container to retrieve the reference from.
    #
    # @return [Array]
    #
    def js_template_ref(name)
      reference_to name, :name, js_templates
    end

    # List user objects on the system.
    #
    # @return [Array]
    #
    def user
      cache.fetch(:user) { Delphix.get(Delphix.user_url).body.result }
    end

    # Retrieve the reference to the specified user object.
    #
    # @param [String] name
    #   The name of the user to retrieve the reference from.
    #
    # @return [Array]
    #
    def user_ref(name)
      reference_to name, :name, user
    end

    # Retrieve the reference to the specified template object.
    #
    # @param [String] name
    #   The name of the template to retrieve the reference from.
    #
    # @return [Array]
    #
    def vdb_ref(name)
      reference_to name, :name, databases
    end
  end
end
