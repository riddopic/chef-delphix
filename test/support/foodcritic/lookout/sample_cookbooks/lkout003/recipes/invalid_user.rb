# user with no uid specified
user 'foo' do
  gid 123
end

# user with no gid specified
user 'bar' do
  uid 456
end

# user with neither uid nor gid specified
user 'baz' do
  password 'foobar'
end

# user with all defaults
user 'qux'
