require 'rspec'
require 'pp'
require 'yaml'

BLOG_KEYS  = %w{ title layout summary tags }
PAGES_KEYS = %w{ title layout summary tags }

$posts, $pages = { }, { }

Dir.glob(["**/*.{md,textile,markdown}", "*.{md,textile,markdown}"]).reject { |x| x =~ /^_(posts|includes)/ }.each do |f|
  begin
    $pages[f] = YAML.load_file(f)
  rescue Psych::SyntaxError
    abort "Can not parse #{f}"
  end
end

Dir.glob(["_posts/**/*.{md,textile,markdown}"]).each do |f|
  begin
    $posts[f] = YAML.load_file(f)
  rescue Psych::SyntaxError
    abort "Can not parse #{f}"
  end
end





describe "YAML front matter" do 

  context "file" do 

    ($posts.merge $pages).each do |file,v|
      subject { v }
      context "#{file}'s YAML" do 
        it { should be_a Hash }
        it { should have_key "layout" }
      end

    end
  end


  context "blog post" do 

    $posts.each do |file,v| 
      subject { v }
      context "#{file} layout" do 
        it { subject["layout"].should == "post" }

        BLOG_KEYS.each do |key|
          it "should have key '#{key}'" do 
            should have_key key
          end
        end
      end
    end
  end # Blog post

  context "Pages" do 

    $pages.each do |file,v| 
      subject {  v }
      context "#{file} layout" do 
        it { subject["layout"].should == "default" }
        
        PAGES_KEYS.each do |key|
          it "should have key '#{key}'" do 
            v.should have_key key
          end
        end
      end
    end
  end # Pages

  context "date format" do 

    ($posts.merge $pages).each do |file,yaml|
      context file do 
        
        it do 
          if yaml.has_key? "date"
            yaml["date"].should be_a Date
          end
        end
      end
    end
  end
  
end # YAML front matter
