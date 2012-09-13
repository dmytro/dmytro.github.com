# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard 'brakeman' do
#   watch('Gemfile')
#   watch('Guardfile')
# end


guard 'rspec', :version => 2, :spec_paths => ["spec", "spec/check_description.rb"] do
  watch(/(.+)\.(textile|md)/) { "spec/yaml_front_matter_spec.rb"}
  watch(/spec\/.*/) { "spec" }
end

