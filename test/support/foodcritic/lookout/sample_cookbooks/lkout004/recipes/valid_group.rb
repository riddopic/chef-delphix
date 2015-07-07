group 'foo' do
  gid 123
end

group 'bar' do
  action :manage
end

group 'baz' do
  action :remove
end

group 'qux' do
  action :modify
end
