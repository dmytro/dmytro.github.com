# Test files in the presentation folder for tags specific for presentations

require 'rspec'
require 'pp'
require 'yaml'

$files = Dir
  .glob(["presentations/*.{md,textile,markdown,html}"])
  .reject { |x| x =~ /(README|example)\./}

required =  %w{ title subtitle}
layout =  'presentation' 


describe "Presentation file"   do 

  $files.each do |file|
    context "#{file}" do
      context "YAML section" do 
        
        it "should be present" do 
          lambda { YAML.load_file(file) }.should_not raise_error
        end
        
        context :variables do
          
          before do 
            @keys = { }
            $files.each do |f|
              @keys[f] = YAML::load_file f          
            end
          end

          let (:all_keys) {  %w{ layout title subtitle date location body } }
          
          it "should have #{required} " do 
            ( required - @keys[file].keys ).should be_empty 
          end
          
          it "should have #{layout} layout" do 
            @keys[file]['layout'].should == layout
          end
          
        end
      end
    end
  end

end



