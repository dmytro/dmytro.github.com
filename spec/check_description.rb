#
# This should not run automatically, only by specifying file name.
# Description is good to have but is not required.
#
require 'rspec'
require 'pp'
require 'yaml'

$pages = { }

Dir.glob("*/**/*.{md,textile,markdown}").reject { |x| x =~ /^_includes/}.each do |f|
  begin
    $pages[f] = YAML.load_file(f)
  rescue Psych::SyntaxError
    true
  end
end

describe "Page" do 
  $pages.each do |file,yaml|
    
    it "#{file} should have description" do
      yaml.should have_key "description"
    end
    
    it "#{file} description and summary should differ" do
      if yaml.has_key? "description"
        yaml["description"].should_not == yaml["summary"]
      end
    end
  end
end


