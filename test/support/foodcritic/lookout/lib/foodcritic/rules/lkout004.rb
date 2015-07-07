rule "LKOUT004", "specify a gid when creating a group" do
  tags %w{lookout style}
  recipe do |ast|
    find_resources(ast, :type => 'group').select do |g|
      gid = resource_attribute(g, 'gid')
      action = resource_attribute(g, 'action')

      is_create_action = action.nil? || action == :create

      is_create_action && gid.nil?
    end
  end
end
