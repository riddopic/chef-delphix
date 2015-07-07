# user with both uid and gid specified
user 'foo' do
  uid 123
  gid 123
end

# don't match on users that are being removed
user 'bar' do
  action :remove
end

# doesn't match on users that are managed
user 'baz' do
  action :manage
end

# doesn't match on users that are modified
user 'qux' do
  action :modify
end
