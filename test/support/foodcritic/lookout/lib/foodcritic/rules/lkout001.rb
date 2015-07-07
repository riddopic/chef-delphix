# Lookout custom foodcritic rules

rule "LKOUT001", "Include a chefspec test for every recipe" do
  tags %w{testing lookout}
  cookbook do |cookbook_path|
    matches = []
    recipes = Dir.glob(File.join(cookbook_path, 'recipes/*.rb'))

    recipes.each do |r|
      recipe_name = File.basename(r, '.rb')
      valid_spec_paths = [
        "spec/recipes/#{recipe_name}_spec.rb",
        "spec/#{recipe_name}_spec.rb"
      ]
      specs_exist = valid_spec_paths.any? do |p|
        recipe_spec = File.join(cookbook_path, p)
        File.exist?(recipe_spec)
      end

      unless specs_exist
        preferred_spec_path = File.join(cookbook_path, valid_spec_paths[0])
        matches << file_match(preferred_spec_path)
      end
    end

    matches
  end
end
