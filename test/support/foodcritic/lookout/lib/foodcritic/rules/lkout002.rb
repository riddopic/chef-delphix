rule "LKOUT002", "apt_repository should not download a key over plain http" do
  tags %w{security lookout}
  recipe do |ast|
    find_resources(ast, :type => 'apt_repository').select do |apt|
      apt_key = resource_attribute(apt, 'key').to_s

      apt_key.match(/^http:\/\//) ? true : false
    end
  end
end
