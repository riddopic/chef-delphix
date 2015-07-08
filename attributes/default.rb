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

default[:delphix].tap do |delphix|
  #
  # The Delphix Server name.
  delphix[:server] = nil
  #
  # The username used to connecto the the Delphix API.
  delphix[:username] = nil
  #
  # The password used to connecto the the Delphix API.
  delphix[:password] = nil
  #
  # The API version running on the Delphix appliance.
  delphix[:api_version] = '1.0.0'

  # The version of the Delphix Gem to use, a setting of nil will use the latest
  # version (not recomended).
  delphix[:gem][:version] = '0.4.0'
end
