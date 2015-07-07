apt_repository "valid_repository" do
  uri "http://foo.bar/ubuntu"
  keyserver "keyserver.foo.bar"
  key "DECAFBAD"
end

apt_repository "valid_repository2" do
  uri "http://foo.bar/ubuntu"
  key "https://foo.bar/fake.key"
end
