# encoding: UTF-8
#
# Author:    Stefano Harding <riddopic@gmail.com>
# License:   Apache License, Version 2.0
# Copyright: (C) 2014-2015 Stefano Harding
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#require "../libraries/vdb"

#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'delphix::default'

delphix_vdb 'your_vdb_name_here' do
  src_db          'the_source_db'
  template_env    'template_environment'
  user            'mail@example.com'
  target_group    'a_target_group'
  target_env      'a_target_environment'
  mount           '/path'
  config_template 'no-mem-template'
end
