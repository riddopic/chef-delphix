rule "LKOUT003", "specify a uid and gid when creating a user" do
  tags %w{lookout style}
  recipe do |ast|
    find_resources(ast, :type => 'user').select do |u|
      uid = resource_attribute(u, 'uid')
      gid = resource_attribute(u, 'gid')
      action = resource_attribute(u, 'action')

      is_create_action = action.nil? || action == :create
      has_no_ids = uid.nil? || gid.nil?

      is_create_action && has_no_ids
    end
  end
end
