#
# This should not run automatically, only by specifying file name.
# Description is good to have but is not required.
#
require 'rspec'
require 'pp'
require 'yaml'

$pages = { }

Dir.glob("_posts/**/*.{md,textile,markdown}").each do |f|
  begin
    $pages[f] = YAML.load_file(f)
  rescue Psych::SyntaxError
    true
  end
end

describe "Post description" do 
  $pages.each do |file,yaml|
    it "#{file}  have tag description" do
      should have_key "description"
    end
  end
end


