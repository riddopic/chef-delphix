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

require_relative 'objects'
require 'poise'

class Chef
  class Resource
    # A resource used to manage a Delphix vDB.
    #
    # @provides :delphix_vdb
    # @action :provision
    #
    class DelphixVdb < Chef::Resource
      include Poise

      # Chef attributes
      identity_attr :vdb
      provides      :delphix_vdb
      state_attrs   :exists

      # Actions
      actions        :provision
      default_action :provision

      # @!attribute vdb
      #   The new container for the provisioned database.
      #   @return [String]
      attribute :vdb,
        kind_of: String,
        name_attribute: true
      # @!attribute src_db
      #   The source db thing.
      #   @return [String]
      attribute :src_db,
        kind_of: String,
        required: true
      # @!attribute template_env
      #   The new container for the provisioned database.
      #   @return [String]
      attribute :template_env,
        kind_of: String,
        required: true
      # @!attribute user
      #   The new container for the provisioned database.
      #   @return [String]
      attribute :user,
        kind_of: String,
        required: true
      # @!attribute target_group
      #   A target group object.
      #   @return [String]
      attribute :target_group,
        kind_of: String,
        required: true
      # @!attribute target_env
      #   A target environment object.
      #   @return [String]
      attribute :target_env,
        kind_of: String,
        required: true
      # @!attribute mount
      #   A target environment object.
      #   @return [String]
      attribute :mount,
        kind_of: String,
        required: true
      # @!attribute config_template
      #   A target template object.
      #   @return [String]
      attribute :config_template,
        kind_of: String,
        required: true
      # @!attribute api_version
      #   The API version running on the Delphix appliance.
      #   @return [String]
      attribute :api_version,
        kind_of: String,
        default: lazy { node[:delphix][:api_version] }
      # @!attribute server
      #   The Delphix Server name.
      #   @return [String]
      attribute :server,
        kind_of: String,
        default: lazy { node[:delphix][:server] }
      # @!attribute api_name
      #   API username to authenticate with.
      #   @return [String]
      attribute :api_name,
        kind_of: String,
        default: lazy { node[:delphix][:username] }
      # @!attribute api_passwd
      #   API password to authenticate with.
      #   @return [String]
      attribute :api_passwd,
        kind_of: String,
        default: lazy { node[:delphix][:password] }

      # @!attribute [rw] :exists
      #   @return [Boolean] true if resource exists.
      attr_accessor :exists

      # Determine if the property exists in the server config. This value is
      # set by the provider when the current resource is loaded.
      #
      # @return [Boolean]
      #
      def exists?
        !@exists.nil? && @exists
      end
    end
  end

  class Provider
    class DelphixVdb < Chef::Provider
      include Delphix::Objects
      include Poise

      # Shortcut to new_resource.
      alias_method :r, :new_resource
      # Shortcut to current_resource.
      alias_method :c, :current_resource

      def initialize(new_resource, run_context)
        super
        require 'delphix'
        Delphix.api_version = node[:delphix][:api_version]
        Delphix.server = node[:delphix][:server]
        Delphix.api_user = node[:delphix][:username]
        Delphix.api_passwd = node[:delphix][:password]

        begin
          Delphix.session
        rescue TypeError
        end

      rescue LoadError
        Chef::Log.error "Missing gem 'delphix'. Use the default recipe to " \
                        "install it first."
      end

      # Boolean indicating if WhyRun is supported by this provider.
      #
      # @return [Boolean]
      #
      def whyrun_supported?
        true
      end

      # Load and return the current state of the resource.
      #
      # @return [Chef::Resource]
      #
      def load_current_resource
        @current_resource ||= Chef::Resource::DelphixVdb.new(r.vdb)
        @current_resource.exists = exists?
      end

      def action_provision
        if @current_resource.exists?
          converge_by "Retrive '#{r.vdb}' connection URL" do
            Chef::Log.info connection_url
          end
        else
          converge_by "Provision '#{r.vdb}' virtual database" do
            provision r.vdb,
              group_ref(r.target_group).first,
              r.mount,
              template_ref(r.config_template).first,
              repo_ref(env_ref(r.target_env).first).first,
              db_ref(r.src_db).first
            job_id = Delphix.last_response[:body][:job]

            if job_id.blank?
              until databases.reject { |db| db.name != name } do
                sleep 3
              end
            else
              until job_completed?(job_id) do
                sleep 3
              end
            end

            template_name  = "#{r.src_db}-#{r.template_env}-template"
            container_name = "#{r.vdb}-#{r.user}-Container"
            create_template(template_name, r.src_db, db_ref(r.src_db).first)
            job_id = Delphix.last_response[:body][:job]

            if job_id.nil? || job_id.empty?
              while js_template_ref.reject { |t| t.name != name } do
                sleep 3
              end
            else
              until job_completed?(job_id) do
                sleep 3
              end
            end

            create_jetstream r.vdb,
              db_ref(r.vdb).first,
              user_ref(r.user).first,
              container_name,
              js_template_ref(template_name)
            connection_url
          end
          r.updated_by_last_action(true)
        end
      end

      private

      # Boolean, true when the vDB exists, false otherwise.
      #
      # @return [Boolean]
      #
      def exists?
        !db_ref(r.vdb).nil? || !db_ref(r.vdb).empty?
      end

      # Return the connection string for the VDB.
      #
      # @return [String]
      #
      def connection_url
        vdb = db_ref(r.vdb)[0]
        url = "http://#{Delphix.server}/resources/json/delphix/database/#{vdb}/connectionInfo"
        node.set[:delphix][r.vdb] = Delphix.get(url).body.result.jdbcStrings
        node.save
        node[:delphix][r.vdb]
      end

      # The parameters to use as input to provision an Oracle databases.
      #
      # @param [String] vdb
      #   The new container for the provisioned database.
      #
      # @param [String] group
      #   Reference to a group object.
      #
      # @param [String] mount
      #   The base mount point to use for the NFS mounts.
      #
      # @param [String] template
      #   A database template to use for provisioning.
      #
      # @param [String] repository
      #   The source repository.
      #
      # @param [String] database
      #   Reference to the container.
      #
      def provision(vdb, group, mount, template, repository, database)
        Delphix.post Delphix.database_url + '/provision',
          container: {
            group: group,
            name: vdb,
            type: 'OracleDatabaseContainer'
          },
          source: {
            type: 'OracleVirtualSource',
            mountBase: mount,
            configTemplate: template,
          },
          sourceConfig: {
            type: 'OracleSIConfig',
            databaseName: vdb,
            uniqueName: vdb,
            repository: repository,
            instance: {
              type: 'OracleInstance',
              instanceName: vdb,
              instanceNumber: 1
            }
          },
          timeflowPointParameters: {
            type: 'TimeflowPointSemantic',
            container: database,
            location: 'LATEST_POINT'
          },
          type: 'OracleProvisionParameters'
      end

      def create_template(template_name, src_db, ref_src_db)
        url = uri_join 'http://', Delphix.server,
          '/resources/json/delphix/jetstream/template'
        Delphix.post url,
          type: 'JSDataTemplateCreateParameters',
          name: template_name,
          dataSources: [
            {
              type: 'JSDataSourceCreateParameters',
              source: {
                type: 'JSDataSource',
                name: src_db
              },
              container: ref_src_db
            }
          ]
      rescue
      end

      def create_jetstream(vdb, src_db, user, container, template)
        url = uri_join 'http://', Delphix.server,
          '/resources/json/delphix/jetstream/container'
        Delphix.post url,
          type: 'JSDataContainerCreateParameters',
          dataSources: [
            {
              type: 'JSDataSourceCreateParameters',
              source: {
                type: 'JSDataSource',
                name: vdb,
              },
              container: src_db
            }
          ],
          owner: user,
          name: container,
          template: template,
          timelinePointParameters: {
            type: 'JSTimelinePointLatestTimeInput',
            sourceDataLayout: template
          }
      end
    end
  end
end
