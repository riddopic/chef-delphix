[![Build Status](https://travis-ci.org/lookout/lookout-foodcritic-rules.png?branch=master)](https://travis-ci.org/lookout/lookout-foodcritic-rules)

# lookout-foodcritic-rules

Custom foodcritic rules used on chef recipes at Lookout.

## Installation

Add this line to your Gemfile in chef-repo:

    gem 'foodcritic-rules'

And then execute `bundle` to install the gem.

Or install it yourself:

    $ gem install foodcritic-rules

## Usage

Once you have installed the gem, simply run foodcritic with the `-G` option:

    foodcritic -t lookout -G cookbooks/

# Rules

## <a id="LKOUT001"></a>LKOUT001: Include a chefspec test for every recipe

We use chefspec for unit testing our recipes.  As a general standard, every
recipe is required to have an associated unit test.

This rules looks for files under the cookbook's `spec` directory named
`<recipe_name>_spec.rb`

For example:

    # Good
    $ ls cookbooks/my_cookbook/recipes/my_recipe.rb 
    cookbooks/my_cookbook/recipes/my_recipe.rb
    $ ls cookbooks/my_cookbook/spec/my_recipe_spec.rb 
    cookbooks/my_cookbook/spec/my_recipe_spec.rb
    
    # Bad
    $ ls cookbooks/my_cookbook/recipes/my_other_recipe.rb 
    cookbooks/my_cookbook/recipes/my_other_recipe.rb
    $ ls cookbooks/my_cookbook/spec/my_other_recipe_spec.rb 
    ls: cannot access cookbooks/my_cookbook/spec/my_other_recipe_spec.rb: No such file or directory

## <a id="LKOUT002"></a>LKOUT002: apt_repository should not download a key over plain http

The `apt_repository` LWRP, provided by the [opscode apt cookbook](https://github.com/opscode-cookbooks/apt),
allows a key to be either downloaded over http(s) or from a keyserver.  Since
downloading the key over http subjects you to a possible man-in-the-middle
attack, you should never use http and always either prefer https or a keyserver.

Note that it's ok for the source uri to be http, as long as the key itself
is downloaded via a secure channel (though https is preferred for *everything*).

```ruby
# Good
apt_repository "valid_repository" do
  uri "http://foo.bar/ubuntu"
  keyserver "keyserver.foo.bar"
  key "DECAFBAD"
end

apt_repository "valid_repository2" do
  uri "http://foo.bar/ubuntu"
  key "https://foo.bar/fake.key"
end

# Bad
apt_repository "valid_repository2" do
  uri "http://foo.bar/ubuntu"
  key "http://foo.bar/fake.key"
end
```

## <a id="LKOUT003"></a>LKOUT003: specify a uid and gid when creating a user

It is possible to create a `user` in chef without specifying a `uid` or `gid`,
which will rely on the system to pick automatically.  When this happens, uids
and gids can get out of sync across your hosts, as well as conflict with any
uids or gids that you have actually specified.

To avoid these pitfalls, we require that all `user` resources  with `action :create`
have a defined uid/gid.  If users are created by outside mechanisms (for example,
post-install scripts in packages) then you should use the `:modify` or `:manage`
actions to control them; when doing this, specifying a uid/gid is not required.

```ruby
# Good
user 'foo' do
  uid 123
  gid 'users'
end

# Bad
user 'bar' do
  password '*'
end

user 'baz' do
  uid '123'
end
```

## <a id="LKOUT004"></a>LKOUT004: specify a gid when creating a group

It is possible to create a `group` in chef without specifying a `gid`, which
will rely on the system to pick automatically.  When this happens, gids can
get out of sync across your hosts, as well as conflict with any gids that you
have actually specified.

To avoid these pitfalls, we require that all `group` resources  with `action :create`
have a defined gid.  If groups are created by outside mechanisms (for example,
post-install scripts in packages) then you should use the `:modify` or `:manage`
actions to control them; when doing this, specifying a gid is not required.

```ruby
# Good
group 'foo' do
  gid 123
end

# Bad
group 'bar'

group 'baz' do
  system true
end
```

# License

Lookout Foodcritic Rules

* Author: James Burgess <james.burgess AT lookout DOT com>
* Copyright: Copyright (c) Lookout, Inc.
* License: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
