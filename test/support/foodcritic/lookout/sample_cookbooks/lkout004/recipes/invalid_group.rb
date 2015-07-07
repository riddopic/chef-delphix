group 'foo'

group 'bar' do
  system true
end

group 'baz' do
  action :create
end
